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

function liferay-get-modules() {
	(cd $(cliferay folder) && $* --name-only | get-module | uniq)
}

function liferay-curl() {
	curl --no-progress-meter -u 'test@liferay.com:test' "$@" | jq
}

function get_current_quarter() {
	current_year=$(date '+%Y')
    month=$(date '+%m')
    case $month in
        01|02|03)
            since="${current_year}-01-01"
            until="${current_year}-04-01"
            ;;
        04|05|06)
            since="${current_year}-04-01"
            until="${current_year}-07-01"
            ;;
        07|08|09)
            since="${current_year}-07-01"
            until="${current_year}-10-01"
            ;;
        10|11|12)
            since="${current_year}-10-01"
            until="$(($current_year + 1))-01-01"
            ;;
    esac
}
