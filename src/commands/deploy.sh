if [[ "$PWD" = */portal-test ]]; then
    cliferay ant deploy install-portal-snapshot && cp ../../bundles/osgi/test/com.liferay.portal.test.jar ../../bundles/osgi/modules
elif [[ "$PWD" = */portal-kernel ]]; then
    cliferay ant deploy install-portal-snapshot
elif [[ "$PWD" = */portal-impl ]]; then
    cliferay ant deploy install-portal-snapshot
elif [[ "$PWD" = *test-util ]]; then
    cliferay gw -a depl
    JAR=$( echo "$(realpath $PWD --relative-to $(cliferay folder))" | sed 's#modules/apps/[^/]*/\([^/]*\)-test-util#\1#' | sed 's/-/./g' | sed 's/\(.*\)/com.liferay.\1.test.util.jar/')
    cp "$(cliferay folder)/../bundles/osgi/test/$JAR" "$(cliferay folder)/../bundles/osgi/modules/"
elif [[ "$PWD" = *gradle-plugins* ]]; then
    cliferay gw installCache updateFileVersions
    git add $(cliferay folder) && git commit -m "DELETE ME"
    cd $(cliferay folder)/modules/sdk/gradle-plugins && gw installCache updateFileVersions
    git add $(cliferay folder) && git commit --amend --no-edit
    cd $(cliferay folder)/modules/sdk/gradle-plugins-defaults && gw installCache updateFileVersions
    git add $(cliferay folder) && git commit --amend --no-edit
    cd $(cliferay folder) && cliferay ant setup-sdk
elif ! [[ "$PWD" = */*-test ]]; then
    cliferay gw -a depl
fi