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
	while read line
	do
		echo "" | (cd $(cliferay folder)/$line; $*)
	done
}

function liferay-get-modules() {
	(cd $(cliferay folder) && $* --name-only | get-module | uniq)
}