if [[ "$PWD" = */portal-test ]]; then
    cliferay ant deploy install-portal-snapshot && cp ../../bundles/osgi/test/com.liferay.portal.test.jar ../../bundles/osgi/modules
elif ! [[ "$PWD" = */*-test ]]; then
    cliferay gw -a depl
fi