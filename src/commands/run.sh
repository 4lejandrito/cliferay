BUNDLES=$(realpath $(cliferay folder)/../bundles)
echo "
# This file was created by cliferay $(cliferay --version).
# Please do not alter it.
# Put your custom properties in the portal-custom.properties file instead.

admin.email.from.address=test@liferay.com
admin.email.from.name=Test Test
default.admin.email.address.prefix=test

company.security.strangers.verify=false
company.default.locale=en_US
company.default.time.zone=UTC
company.default.web.id=liferay.com

jdbc.default.driverClassName=com.mysql.cj.jdbc.Driver
jdbc.default.password=root
jdbc.default.url=jdbc:mysql://localhost/lportal?characterEncoding=UTF-8&dontTrackOpenResources=true&holdResultsOpenOverStatementClose=true&serverTimezone=GMT&useFastDateParsing=false&useUnicode=true
jdbc.default.username=root

liferay.home=$BUNDLES

setup.wizard.enabled=false
terms.of.use.required=false
passwords.default.policy.change.required=false
users.reminder.queries.required=false
users.reminder.queries.enabled=false
enterprise.product.notification.enabled=false

feature.flag.ui.visible[dev]=true

module.framework.properties.osgi.console=11311

include-and-override=\${liferay.home}/portal-custom.properties
" > $BUNDLES/portal-ext.properties

if [ ! -f "$BUNDLES/portal-custom.properties" ]; then
    echo "# Override your config here, don't touch portal-ext.properties" > $BUNDLES/portal-custom.properties
fi

$(cliferay tomcat-folder)/bin/catalina.sh ${args["command"]:-jpda} run
