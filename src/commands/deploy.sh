if [[ "$PWD" = */portal-test ]]; then
    cliferay ant deploy install-portal-snapshot && cp ../../bundles/osgi/test/com.liferay.portal.test.jar ../../bundles/osgi/modules
elif [[ "$PWD" = */portal-kernel ]]; then
    cliferay ant deploy install-portal-snapshot
elif [[ "$PWD" = */portal-impl ]]; then
    cliferay ant deploy install-portal-snapshot
elif [[ "$PWD" = *test-util ]]; then
    cliferay gw -a depl
    JAR=$( echo "$(realpath $PWD --relative-to $(cliferay home))" | sed 's#modules/apps/[^/]*/\([^/]*\)-test-util#\1#' | sed 's/-/./g' | sed 's/\(.*\)/com.liferay.\1.test.util.jar/')
    cp "$(cliferay home)/../bundles/osgi/test/$JAR" "$(cliferay home)/../bundles/osgi/modules/"
elif [[ "$PWD" = *gradle-plugins* ]]; then
    cliferay gw installCache updateFileVersions
    git add $(cliferay home) && git commit -m "DELETE ME"
    cd $(cliferay home)/modules/sdk/gradle-plugins && gw installCache updateFileVersions
    git add $(cliferay home) && git commit --amend --no-edit
    cd $(cliferay home)/modules/sdk/gradle-plugins-defaults && gw installCache updateFileVersions
    git add $(cliferay home) && git commit --amend --no-edit
    cd $(cliferay home) && cliferay ant setup-sdk
elif ! [[ "$PWD" = */*-test ]]; then
    cliferay gw -a depl
fi