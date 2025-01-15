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

function get_current_quarter() {
    current_year=$(date '+%Y')
    month=$(date '+%m')

    if [ -n "$Q" ]; then
        current_year=$(echo "$Q" | cut -d'-' -f1)
        quarter=$(echo "$Q" | cut -d'-' -f2 | tr -d 'q')
    else
        case $month in
            01|02|03) quarter=1 ;;
            04|05|06) quarter=2 ;;
            07|08|09) quarter=3 ;;
            10|11|12) quarter=4 ;;
        esac
    fi
    
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
}

