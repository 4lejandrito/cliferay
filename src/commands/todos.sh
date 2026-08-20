DATA_FOLDER=$(cliferay data-folder)
ROOT=$DATA_FOLDER/todo
TABS=(todo done forgotten people knowledge)

declare -A TITLES

entries_of() {
    if [ "$1" = todo ]; then
        ls -1 "$ROOT/$1" 2> /dev/null | sort
    else
        ls -1 "$ROOT/$1" 2> /dev/null | sort -r
    fi
}

# One pass over the whole tab, so redrawing never has to read a file.
prefetch_titles() {
    local tab=$1 line name
    while IFS= read -r line; do
        name=${line%%:#*}
        name=${name#"$ROOT/$tab/"}
        name=${name%/todo.md}
        TITLES[$tab/$name]=${line#*:# }
    done < <(grep -m 1 -H '^# ' "$ROOT/$tab"/*/todo.md 2> /dev/null)
}

title_of() {
    local key=$1/$2
    if [ -z "${TITLES[$key]+set}" ]; then
        TITLES[$key]=$(sed -n '/^# /{s/^# //p;q;}' "$ROOT/$key/todo.md" 2> /dev/null)
    fi
    TITLE=${TITLES[$key]}
    [ -z "$TITLE" ] && TITLE=$2
    return 0
}

# Plain list when piped, so scripts and pipelines keep working.
if [ ! -t 1 ] && [ -z "$CLIFERAY_TODOS_TUI" ]; then
    while read -r NAME; do
        [ -f "$ROOT/todo/$NAME/todo.md" ] || continue
        title_of todo "$NAME"
        echo "$ROOT/todo/$NAME/todo.md $TITLE"
    done < <(entries_of todo) | head -10
    exit 0
fi

DIM=$'\e[2m'
OFF=$'\e[0m'
INVERT=$'\e[7m'
HEAD=$'\e[1;36m'
TABON=$'\e[7;36m'
OK=$'\e[32m'
LINK=$'\e]8;;'
LABEL=$'\e\\'
UNLINK=$'\e]8;;\e\\'
URL='https?://[^[:space:]<>"]+'
# Sentence punctuation right after a link is not part of it.
NOT_URL='[.,;:!?)>]$'

TAB=0
SEL=(0 0 0 0 0)
TOP=(0 0 0 0 0)
COUNTS=(0 0 0 0 0)
STATUS=""
COMMITS=0
MODE=list
READ_TOP=0
TITLE=""
declare -a ENTRIES
declare -a CONTENT

geometry() {
    ROWS=$(tput lines 2> /dev/null || echo 24)
    COLS=$(tput cols 2> /dev/null || echo 80)
    BODY=$((ROWS - 4))
    [ "$BODY" -lt 1 ] && BODY=1
    WIDTH=$((COLS - 5))
    [ "$WIDTH" -lt 10 ] && WIDTH=10
    printf -v RULE '─%.0s' $(seq 1 $((COLS - 1)))
    return 0
}

clamp() {
    if [ "${#ENTRIES[@]}" -eq 0 ]; then
        SEL[$TAB]=0
        return
    fi
    [ "${SEL[$TAB]}" -ge "${#ENTRIES[@]}" ] && SEL[$TAB]=$((${#ENTRIES[@]} - 1))
    [ "${SEL[$TAB]}" -lt 0 ] && SEL[$TAB]=0
    return 0
}

reload() {
    local name index tab=${TABS[$TAB]}
    prefetch_titles "$tab"

    ENTRIES=()
    while read -r name; do
        [ -d "$ROOT/$tab/$name" ] || continue
        ENTRIES+=("$name")
    done < <(entries_of "$tab")

    for index in "${!TABS[@]}"; do
        COUNTS[$index]=$(ls -1 "$ROOT/${TABS[$index]}" 2> /dev/null | wc -l | tr -d ' ')
    done

    clamp
}

selected_file() {
    echo "$ROOT/${TABS[$TAB]}/${ENTRIES[${SEL[$TAB]}]}/todo.md"
}

git_commit() {
    git -C "$DATA_FOLDER" rev-parse --git-dir > /dev/null 2>&1 || return 0
    git -C "$DATA_FOLDER" add -A "$ROOT" > /dev/null 2>&1
    if git -C "$DATA_FOLDER" commit -q -m "$1" > /dev/null 2>&1; then
        COMMITS=$((COMMITS + 1))
    fi
}

# Keeps the index dense, so 001 is always the most important.
renumber() {
    local index=1 name target
    while read -r name; do
        target=$(printf '%03d' $index)-${name#*-}
        [ "$name" != "$target" ] && mv "$ROOT/todo/$name" "$ROOT/todo/$target"
        index=$((index + 1))
    done < <(ls -1 "$ROOT/todo" 2> /dev/null | sort)
    TITLES=()
}

free_name() {
    local folder=$1 base=$2 target=$2 suffix=2
    while [ -e "$ROOT/$folder/$target" ]; do
        target=$base-$suffix
        suffix=$((suffix + 1))
    done
    echo "$target"
}

slug_of() {
    case ${TABS[$TAB]} in
        todo) echo "${1#*-}" ;;
        *) sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}-//' <<< "$1" ;;
    esac
}

# Reads a full escape sequence into SEQ (arrows are short, modified arrows are not).
read_escape() {
    local ch
    SEQ=""
    read -rsn1 -t 0.05 ch || return 0
    SEQ=$ch
    if [ "$ch" != "[" ] && [ "$ch" != "O" ]; then
        return 0
    fi
    while read -rsn1 -t 0.05 ch; do
        SEQ+=$ch
        case $ch in
            [A-Za-z~]) break ;;
        esac
    done
    return 0
}

screen_on() {
    printf '\e[?1049h\e[?25l\e[?7l'
}

screen_off() {
    printf '\e[?7h\e[?1049l\e[?25h'
}

# Builds the key hints, dropping any that would not fit on the line.
hints() {
    local width=0 piece
    HINTS=""
    while [ "$#" -gt 1 ]; do
        piece=$((${#1} + ${#2} + 3))
        [ $((width + piece)) -gt $((COLS - 4)) ] && break
        HINTS+="$DIM$1$OFF $2  "
        width=$((width + piece))
        shift 2
    done
    return 0
}

tab_bar() {
    local index label
    BAR=$'\e[H\e[K  '
    for index in "${!TABS[@]}"; do
        label=" ${TABS[$index]^} ${COUNTS[$index]} "
        if [ "$index" = "$TAB" ]; then
            BAR+="$TABON$label$OFF "
        else
            BAR+="$DIM$label$OFF "
        fi
    done
    return 0
}

draw_list() {
    local frame sel top row line name text
    sel=${SEL[$TAB]}
    top=${TOP[$TAB]}
    [ "$sel" -lt "$top" ] && top=$sel
    [ "$sel" -ge $((top + BODY)) ] && top=$((sel - BODY + 1))
    [ "$top" -lt 0 ] && top=0
    TOP[$TAB]=$top

    tab_bar
    frame=$BAR
    frame+=$'\n\e[K'"$DIM$RULE$OFF"

    for ((line = 0; line < BODY; line++)); do
        row=$((top + line))
        frame+=$'\n\e[K'
        [ "$row" -lt "${#ENTRIES[@]}" ] || continue

        name=${ENTRIES[$row]}
        title_of "${TABS[$TAB]}" "$name"
        printf -v text '%-*s' "$WIDTH" "$TITLE"
        text=${text:0:$WIDTH}
        if [ "$row" = "$sel" ]; then
            frame+="$INVERT ▸ $text $OFF"
        else
            frame+="   $text"
        fi
    done

    frame+=$'\n\e[K'"$DIM$RULE$OFF"
    frame+=$'\n\e[K  '
    if [ -n "$STATUS" ]; then
        frame+="$OK${STATUS:0:$((COLS - 4))}$OFF"
    else
        case ${TABS[$TAB]} in
            todo) hints up/down select left/right tab enter read o edit shift+up/down priority t top d done f forget n new q quit ;;
            done | forgotten) hints up/down select left/right tab enter read o edit d reopen q quit ;;
            *) hints up/down select left/right tab enter read o edit q quit ;;
        esac
        frame+=$HINTS
    fi

    printf '%s' "$frame"
}

# Elides text to fit, keeping both ends, which are what identifies a link.
elide() {
    local text=$1 room=$2 keep
    ELIDED=$text
    ELIDED_WIDTH=${#text}
    [ "$ELIDED_WIDTH" -le "$room" ] && return 0
    ELIDED_WIDTH=$room
    if [ "$room" -lt 3 ]; then
        ELIDED=${text:0:$room}
        return 0
    fi
    keep=$(((room - 1) / 3))
    [ "$keep" -lt 1 ] && keep=1
    ELIDED=${text:0:$((room - 1 - keep))}…${text: -$keep}
    return 0
}

# Links stay clickable however narrow the terminal is: the exact target travels
# in an OSC 8 escape, so the label on screen can be elided instead of cut in half.
linkify() {
    local text=$1 room=$2 match url head
    LINKED=""
    while [ "$room" -gt 0 ] && [[ $text =~ $URL ]]; do
        match=$BASH_REMATCH
        head=${text%%"$match"*}
        text=${text#*"$match"}
        url=$match
        while [[ $url =~ $NOT_URL ]]; do url=${url%?}; done
        text=${match#"$url"}$text
        if [ "${#head}" -ge "$room" ]; then
            LINKED+=${head:0:$room}
            return 0
        fi
        LINKED+=$head
        room=$((room - ${#head}))
        elide "$url" "$room"
        LINKED+="$LINK$url$LABEL$ELIDED$UNLINK"
        room=$((room - ELIDED_WIDTH))
    done
    LINKED+=${text:0:$room}
    return 0
}

draw_read() {
    local frame line row raw
    title_of "${TABS[$TAB]}" "${ENTRIES[${SEL[$TAB]}]}"

    [ "$READ_TOP" -gt $((${#CONTENT[@]} - BODY)) ] && READ_TOP=$((${#CONTENT[@]} - BODY))
    [ "$READ_TOP" -lt 0 ] && READ_TOP=0

    frame=$'\e[H\e[K  '"$DIM${TABS[$TAB]^}$OFF  $HEAD${TITLE:0:$((WIDTH - 12))}$OFF"
    frame+=$'\n\e[K'"$DIM$RULE$OFF"

    for ((line = 0; line < BODY; line++)); do
        row=$((READ_TOP + line))
        frame+=$'\n\e[K'
        [ "$row" -lt "${#CONTENT[@]}" ] || continue
        raw=${CONTENT[$row]}
        # A frontmatter link runs to the end of the line, spaces and all.
        [[ $raw =~ ^([[:space:]]+-[[:space:]])(https?://.+)$ ]] && raw=${BASH_REMATCH[1]}${BASH_REMATCH[2]// /%20}
        linkify "$raw" "$WIDTH"
        case $raw in
            '# '* | '## '* | '### '*) frame+="  $HEAD$LINKED$OFF" ;;
            '---' | 'created:'* | 'links:'* | 'labels:'* | 'due'* | '  - http'*) frame+="  $DIM$LINKED$OFF" ;;
            '- [x]'*) frame+="  $OK$LINKED$OFF" ;;
            *) frame+="  $LINKED" ;;
        esac
    done

    frame+=$'\n\e[K'"$DIM$RULE$OFF"
    frame+=$'\n\e[K  '
    if [ "${#CONTENT[@]}" -gt "$BODY" ]; then
        frame+="$DIM$((READ_TOP + 1))-$((READ_TOP + BODY)) of ${#CONTENT[@]}$OFF  "
    fi
    case ${TABS[$TAB]} in
        todo) hints up/down scroll o edit d done f forget q back ;;
        done | forgotten) hints up/down scroll o edit d reopen q back ;;
        *) hints up/down scroll o edit q back ;;
    esac
    frame+=$HINTS

    printf '%s' "$frame"
}

draw() {
    if [ "$MODE" = read ]; then
        draw_read
    else
        draw_list
    fi
}

enter_read() {
    [ "${#ENTRIES[@]}" -gt 0 ] || return
    mapfile -t CONTENT < <(expand -t 4 "$(selected_file)" 2> /dev/null)
    READ_TOP=0
    MODE=read
}

prompt() {
    local reply
    printf '\e[%d;1H\e[K%s  %s%s ' "$ROWS" "$HEAD" "$1" "$OFF"
    printf '\e[?25h'
    IFS= read -r reply
    printf '\e[?25l'
    echo "$reply"
}

open_selected() {
    [ "${#ENTRIES[@]}" -eq 0 ] && return
    local file
    file=$(selected_file)
    if [ -n "$EDITOR" ]; then
        screen_off
        $EDITOR "$file"
        screen_on
    elif command -v code > /dev/null 2>&1; then
        code "$file" > /dev/null 2>&1 &
        STATUS="Opened in VS Code"
    else
        screen_off
        "${PAGER:-less}" "$file"
        screen_on
    fi
}

action_done() {
    [ "${TABS[$TAB]}" = todo ] || return
    [ "${#ENTRIES[@]}" -gt 0 ] || return
    local name target done_title
    name=${ENTRIES[${SEL[$TAB]}]}
    title_of todo "$name"
    done_title=$TITLE
    target=$(free_name done "$(date -u +%Y-%m-%dT%H-%M-%S)-$(slug_of "$name")")
    mkdir -p "$ROOT/done"
    mv "$ROOT/todo/$name" "$ROOT/done/$target"
    renumber
    git_commit "Done: $done_title"
    reload
    STATUS="Done: $done_title"
}

action_forget() {
    [ "${TABS[$TAB]}" = todo ] || return
    [ "${#ENTRIES[@]}" -gt 0 ] || return
    local name target forgotten_title
    name=${ENTRIES[${SEL[$TAB]}]}
    title_of todo "$name"
    forgotten_title=$TITLE
    target=$(free_name forgotten "$(date -u +%Y-%m-%dT%H-%M-%S)-$(slug_of "$name")")
    mkdir -p "$ROOT/forgotten"
    mv "$ROOT/todo/$name" "$ROOT/forgotten/$target"
    renumber
    git_commit "Forget: $forgotten_title"
    reload
    STATUS="Forgot: $forgotten_title"
}

action_reopen() {
    local from=${TABS[$TAB]}
    [ "$from" = done ] || [ "$from" = forgotten ] || return
    [ "${#ENTRIES[@]}" -gt 0 ] || return
    local name target open_title slug
    name=${ENTRIES[${SEL[$TAB]}]}
    title_of "$from" "$name"
    open_title=$TITLE
    slug=$(slug_of "$name")
    mkdir -p "$ROOT/todo"
    # Back as the most important todo, and always shown on the todo tab.
    target=$(free_name todo "000-$slug")
    mv "$ROOT/$from/$name" "$ROOT/todo/$target"
    renumber
    git_commit "Reopen: $open_title"
    TAB=0
    SEL[$TAB]=0
    TOP[$TAB]=0
    reload
    STATUS="Reopened: $open_title"
}

action_move() {
    case ${TABS[$TAB]} in
        todo) action_done ;;
        done | forgotten) action_reopen ;;
    esac
}

action_swap() {
    [ "${TABS[$TAB]}" = todo ] || return
    local other=$1 here there
    if [ "$other" -lt 0 ] || [ "$other" -ge "${#ENTRIES[@]}" ]; then
        return
    fi
    here=${ENTRIES[${SEL[$TAB]}]}
    there=${ENTRIES[$other]}
    title_of todo "$here"
    mv "$ROOT/todo/$here" "$ROOT/todo/.swap"
    mv "$ROOT/todo/$there" "$ROOT/todo/${here%%-*}-${there#*-}"
    mv "$ROOT/todo/.swap" "$ROOT/todo/${there%%-*}-${here#*-}"
    SEL[$TAB]=$other
    TITLES=()
    git_commit "Reprioritize: $TITLE"
    reload
}

action_top() {
    [ "${TABS[$TAB]}" = todo ] || return
    [ "${#ENTRIES[@]}" -gt 0 ] || return
    local name slug
    name=${ENTRIES[${SEL[$TAB]}]}
    slug=$(slug_of "$name")
    title_of todo "$name"
    mv "$ROOT/todo/$name" "$ROOT/todo/000-$slug"
    renumber
    SEL[$TAB]=0
    git_commit "Reprioritize: $TITLE"
    reload
}

action_new() {
    local title
    title=$(prompt "New todo:")
    [ -z "$title" ] && return
    cliferay todo "$title" > /dev/null
    TAB=0
    TITLES=()
    reload
    SEL[$TAB]=0
    TOP[$TAB]=0
    STATUS="Added: $title"
}

switch_tab() {
    TAB=$(((TAB + $1 + ${#TABS[@]}) % ${#TABS[@]}))
    reload
}

trap 'screen_off; exit' INT TERM
trap 'geometry; draw' WINCH

geometry
screen_on
reload
draw

while true; do
    IFS= read -rsn1 KEY
    CODE=$?
    if [ "$CODE" -gt 128 ]; then
        continue
    elif [ "$CODE" -ne 0 ]; then
        break
    fi
    STATUS=""

    if [ "$MODE" = read ]; then
        case $KEY in
            $'\e')
                read_escape
                case $SEQ in
                    '[A' | 'OA') READ_TOP=$((READ_TOP - 1)) ;;
                    '[B' | 'OB') READ_TOP=$((READ_TOP + 1)) ;;
                    '[5~') READ_TOP=$((READ_TOP - BODY)) ;;
                    '[6~') READ_TOP=$((READ_TOP + BODY)) ;;
                    '') MODE=list ;;
                esac
                ;;
            q | '') MODE=list ;;
            o) open_selected ;;
            d)
                case ${TABS[$TAB]} in
                    todo | done | forgotten)
                        action_move
                        MODE=list
                        ;;
                esac
                ;;
            f)
                if [ "${TABS[$TAB]}" = todo ]; then
                    action_forget
                    MODE=list
                fi
                ;;
            j) READ_TOP=$((READ_TOP + 1)) ;;
            k) READ_TOP=$((READ_TOP - 1)) ;;
            g) READ_TOP=0 ;;
            G) READ_TOP=${#CONTENT[@]} ;;
        esac
        # Only paint once the keyboard buffer is empty, so held keys do not queue frames.
        read -t 0 || draw
        continue
    fi

    case $KEY in
        $'\e')
            read_escape
            case $SEQ in
                '[A' | 'OA') SEL[$TAB]=$((${SEL[$TAB]} - 1)) ;;
                '[B' | 'OB') SEL[$TAB]=$((${SEL[$TAB]} + 1)) ;;
                '[C' | 'OC') switch_tab 1 ;;
                '[D' | 'OD') switch_tab -1 ;;
                '[5~') SEL[$TAB]=$((${SEL[$TAB]} - BODY)) ;;
                '[6~') SEL[$TAB]=$((${SEL[$TAB]} + BODY)) ;;
                '[1;2A' | '[a') action_swap $((${SEL[$TAB]} - 1)) ;;
                '[1;2B' | '[b') action_swap $((${SEL[$TAB]} + 1)) ;;
            esac
            ;;
        '') enter_read ;;
        q) break ;;
        o) open_selected ;;
        j) SEL[$TAB]=$((${SEL[$TAB]} + 1)) ;;
        k) SEL[$TAB]=$((${SEL[$TAB]} - 1)) ;;
        l) switch_tab 1 ;;
        h) switch_tab -1 ;;
        g) SEL[$TAB]=0 ;;
        G) SEL[$TAB]=$((${#ENTRIES[@]} - 1)) ;;
        t) action_top ;;
        d) action_move ;;
        f) action_forget ;;
        n) action_new ;;
        r)
            TITLES=()
            reload
            ;;
    esac

    clamp
    # Only paint once the keyboard buffer is empty, so held keys do not queue frames.
    read -t 0 || draw
done

screen_off

if [ "$COMMITS" -gt 0 ]; then
    if git -C "$DATA_FOLDER" push -q 2> /dev/null; then
        echo "Pushed $COMMITS change(s)"
    else
        echo "Could not push, $COMMITS change(s) committed locally"
    fi
fi
