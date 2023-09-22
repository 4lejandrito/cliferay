if [[ "$PWD" = */portal-test ]]; then
    cliferay ant deploy install-portal-snapshot && cp ../../bundles/osgi/test/com.liferay.portal.test.jar ../../bundles/osgi/modules
elif [[ "$PWD" = */portal-kernel ]]; then
    cliferay ant deploy install-portal-snapshot
elif ! [[ "$PWD" = */*-test ]]; then
    cliferay gw -a depl
fi