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

function open() {
	npx -y open-cli $*
}