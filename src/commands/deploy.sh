if [[ "$PWD" = */portal-test ]]; then
    cliferay ant deploy install-portal-snapshot && cp ../../bundles/osgi/test/com.liferay.portal.test.jar ../../bundles/osgi/modules
elif [[ "$PWD" = */portal-kernel ]]; then
    cliferay ant deploy install-portal-snapshot
elif [[ "$PWD" = *test-util ]]; then
    cliferay gw -a depl
    JAR=$( echo "$(realpath $PWD --relative-to $(cliferay folder))" | sed 's#modules/apps/[^/]*/\([^/]*\)-test-util#\1#' | sed 's/-/./g' | sed 's/\(.*\)/com.liferay.\1.test.util.jar/')
    cp "$(cliferay folder)/../bundles/osgi/test/$JAR" "$(cliferay folder)/../bundles/osgi/modules/"
elif ! [[ "$PWD" = */*-test ]]; then
    cliferay gw -a depl
fi