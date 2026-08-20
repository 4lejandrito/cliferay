TITLE="${other_args[*]}"
URLS=($(grep -oE 'https?://[^ ]+' <<<"$TITLE" || true))
CLEAN_TITLE=$(echo "$TITLE" | sed -E 's_https?://[^ ]+__g; s/[[:space:]]+/ /g; s/^ //; s/ $//')

DATA_FOLDER=$(cliferay data-folder)
FOLDER=$DATA_FOLDER/todo/todo
mkdir -p "$FOLDER"

SLUG=$(echo "$CLEAN_TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' | cut -c1-60 | sed -E 's/-+$//')
SLUG=${SLUG:-untitled}
NAME=000-$SLUG
SUFFIX=2

while [ -e "$FOLDER/$NAME" ]; do
    NAME=000-$SLUG-$SUFFIX
    SUFFIX=$((SUFFIX + 1))
done

TODO_FOLDER=$FOLDER/$NAME

mkdir -p "$TODO_FOLDER"
FILE=$TODO_FOLDER/todo.md

{
    echo "---"
    echo "created: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    if [ ${#URLS[@]} -gt 0 ]; then
        echo "links:"
        for URL in "${URLS[@]}"; do
            echo "  - $URL"
        done
    fi
    echo "---"
    echo ""
    echo "# $CLEAN_TITLE"
} > "$FILE"

# A fresh todo is the most important one, so the rest shift one down. Renaming
# from the bottom up keeps every target free while the list slides.
INDEX=$(ls -1 "$FOLDER" | wc -l | tr -d ' ')
while read -r FOUND; do
    TARGET=$(printf '%03d' $INDEX)-${FOUND#*-}
    if [ "$FOUND" != "$TARGET" ]; then
        mv "$FOLDER/$FOUND" "$FOLDER/$TARGET"
        [ "$FOUND" = "$NAME" ] && TODO_FOLDER=$FOLDER/$TARGET
    fi
    INDEX=$((INDEX - 1))
done < <(ls -1 "$FOLDER" | sort -r)
FILE=$TODO_FOLDER/todo.md

if git -C "$DATA_FOLDER" rev-parse --git-dir > /dev/null 2>&1; then
    git -C "$DATA_FOLDER" add -A "$FOLDER"
    git -C "$DATA_FOLDER" commit -q -m "Todo: $CLEAN_TITLE"
    git -C "$DATA_FOLDER" push -q || echo "Could not push, the todo is committed locally"
fi

echo "$FILE"
