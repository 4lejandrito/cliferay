function get-module() {
	while read line
	do
		if test -f $line/bnd.bnd; then
			echo "$line";
		elif [ "$line" != "." ]; then
			(dirname $line | get-module)
		fi
	done
}

function run-stdin() {
	set +e
	while read line
	do
		echo "" | (cd $(cliferay home)/$line; $*)
	done
	set -e
}

function liferay-curl() {
	curl --no-progress-meter -u 'test@liferay.com:test' "$@" | jq
}

function get_current_period() {
    current_year=$(date -u '+%Y')
    month=$(date -u '+%m')

    if [ -n "$Q" ]; then
        current_year=$(echo "$Q" | cut -d'-' -f1)
        quarter=$(echo "$Q" | cut -d'-' -f2 | tr -d 'q')
        case $quarter in
            1)
                since="${current_year}-01-01T00:00:00Z"
                until="${current_year}-04-01T00:00:00Z"
                ;;
            2)
                since="${current_year}-04-01T00:00:00Z"
                until="${current_year}-07-01T00:00:00Z"
                ;;
            3)
                since="${current_year}-07-01T00:00:00Z"
                until="${current_year}-10-01T00:00:00Z"
                ;;
            4)
                since="${current_year}-10-01T00:00:00Z"
                until="$(($current_year + 1))-01-01T00:00:00Z"
                ;;
            *)
                echo "Invalid quarter specified. Use format yyyy-qx (e.g., 2023-q1)."
                return 1
                ;;
        esac
    else
        since="2000-01-01T00:00:00Z"
        until="${current_year}-12-31T23:59:59Z"
    fi
}

function get_git_log_period() {
    get_current_period
    echo "--since=\"$since\" --until=\"$until\""
}

function deploy_activation_key() {
    mkdir -p $1/deploy
    cp $(cliferay data-folder)/activation-* $1/deploy/ 2>/dev/null || true
}

# Locate a GNU sed and expose it as $SED.
#
# This follows the Autoconf convention (AC_PROG_SED sets the SED output
# variable) that Kubernetes also uses in kube::util::ensure-gnu-sed.
#
# BSD sed, which is what macOS ships, is not a drop-in replacement for GNU sed:
# -i requires a backup suffix argument there, and GNU regex extensions such as
# \s or \+ silently match nothing instead of failing.
#
#     ensure-gnu-sed
#
#     $SED -i 's/foo/bar/' "$file"
function ensure-gnu-sed() {
    if sed --version 2>/dev/null | grep -q GNU; then
        SED=sed
    elif command -v gsed >/dev/null 2>&1; then
        SED=gsed
    else
        echo "Failed to find GNU sed as sed or gsed." >&2
        echo "On macOS: brew install gnu-sed" >&2
        exit 1
    fi
}
