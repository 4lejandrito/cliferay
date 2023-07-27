root=$(git rev-parse --show-toplevel 2> /dev/null || true)
if [[ $root == *liferay-portal* ]]; then
    echo $root
else
    echo $LIFERAY_HOME
fi
