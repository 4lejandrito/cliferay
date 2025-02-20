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
		echo "" | (cd $(cliferay folder)/$line; $*)
	done
	set -e
}

function liferay-curl() {
	curl --no-progress-meter -u 'test@liferay.com:test' "$@" | jq
}

function get_current_period() {
    current_year=$(date '+%Y')
    month=$(date '+%m')

    if [ -n "$Q" ]; then
        current_year=$(echo "$Q" | cut -d'-' -f1)
        quarter=$(echo "$Q" | cut -d'-' -f2 | tr -d 'q')
        case $quarter in
            1)
                since="${current_year}-01-01"
                until="${current_year}-04-01"
                ;;
            2)
                since="${current_year}-04-01"
                until="${current_year}-07-01"
                ;;
            3)
                since="${current_year}-07-01"
                until="${current_year}-10-01"
                ;;
            4)
                since="${current_year}-10-01"
                until="$(($current_year + 1))-01-01"
                ;;
            *)
                echo "Invalid quarter specified. Use format yyyy-qx (e.g., 2023-q1)."
                return 1
                ;;
        esac
    else
        since="2000-01-01"
        until="${current_year}-12-31"
    fi
}

function get_git_log_period() {
    get_current_period
    echo "--since=\"$since\" --until=\"$until\""
}
