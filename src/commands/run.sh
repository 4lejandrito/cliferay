BUNDLES=$(realpath $(cliferay folder)/../bundles)
PROJECT_FOLDER=$(realpath $(cliferay folder)/../)
echo "
# This file was created by cliferay $(cliferay --version).
# Please do not alter it.
# Put your custom properties in the portal-custom.properties file instead.

admin.email.from.address=test@liferay.com
admin.email.from.name=Test Test
default.admin.email.address.prefix=test

captcha.enforce.disabled=true

company.security.strangers.verify=false
company.default.locale=en_US
company.default.time.zone=UTC
company.default.web.id=liferay.com

jdbc.default.driverClassName=com.mysql.cj.jdbc.Driver
jdbc.default.password=root
jdbc.default.url=jdbc:mysql://localhost/$(cliferay db-name)?characterEncoding=UTF-8&dontTrackOpenResources=true&holdResultsOpenOverStatementClose=true&serverTimezone=GMT&useFastDateParsing=false&useUnicode=true
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

if [[ ${args[--clustered]} -eq 1 ]]; then

  # Add cluster property to 'portal-ext.properties'
  echo "
  # Portal clustered mode enabled
  cluster.link.enabled=true
  " >> $BUNDLES/portal-ext.properties

  PROJECT_FOLDER=$(realpath $(cliferay folder)/../)

  # Copy 'bundles' as 'bundles2' for the second node
  echo "Copying the content of 'bundles'..." && rm -rf $PROJECT_FOLDER/bundles2 && cp -r $PROJECT_FOLDER/bundles $PROJECT_FOLDER/bundles2 && echo "Done!"

  BUNDLES2=$(realpath $(cliferay folder)/../bundles2)

  # Change 'portal-ext.properties'
  echo "
  # This file was created by cliferay $(cliferay --version).
  # Please do not alter it.
  # Put your custom properties in the portal-custom.properties file instead.

  admin.email.from.address=test@liferay.com
  admin.email.from.name=Test Test
  default.admin.email.address.prefix=test

  captcha.enforce.disabled=true

  company.security.strangers.verify=false
  company.default.locale=en_US
  company.default.time.zone=UTC
  company.default.web.id=liferay.com

  jdbc.default.driverClassName=com.mysql.cj.jdbc.Driver
  jdbc.default.password=root
  jdbc.default.url=jdbc:mysql://localhost/$(cliferay db-name)?characterEncoding=UTF-8&dontTrackOpenResources=true&holdResultsOpenOverStatementClose=true&serverTimezone=GMT&useFastDateParsing=false&useUnicode=true
  jdbc.default.username=root

  liferay.home=$BUNDLES2

  setup.wizard.enabled=false
  terms.of.use.required=false
  passwords.default.policy.change.required=false
  users.reminder.queries.required=false
  users.reminder.queries.enabled=false
  enterprise.product.notification.enabled=false

  feature.flag.ui.visible[dev]=true

  include-and-override=\${liferay.home}/portal-custom.properties

  # Portal clustered mode enabled
  cluster.link.enabled=true
  " > $BUNDLES2/portal-ext.properties

  # Add the necessary elasticsearch7 configurations for clustering with second node
  mkdir -p $BUNDLES2/osgi/configs
  echo '
  operationMode="REMOTE"
  networkHostAddresses=["http://localhost:9201"]
  clusterName="LiferayElasticsearchCluster"
  ' > $BUNDLES2/osgi/configs/com.liferay.portal.search.elasticsearch7.configuration.ElasticsearchConfiguration.config

  sed -i 's/^[ \t]*//' $BUNDLES2/osgi/configs/com.liferay.portal.search.elasticsearch7.configuration.ElasticsearchConfiguration.config

  BUNDLES2_TOMCAT_FOLDER=$(cliferay tomcat-folder | sed 's|/bundles/|/bundles2/|')

  # Modify the second node ports to avoid collision
  sed -i -e 's/8080/9080/g' -e 's/8005/9005/g' -e 's/8443/9443/g' "$BUNDLES2_TOMCAT_FOLDER/conf/server.xml"

fi

if [ ! -f "$BUNDLES/portal-custom.properties" ]; then
    echo "# Override your config here, don't touch portal-ext.properties" > $BUNDLES/portal-custom.properties
fi

mkdir -p $BUNDLES/osgi/configs
echo 'maxChallenges=I"-1"' > $BUNDLES/osgi/configs/com.liferay.captcha.configuration.CaptchaConfiguration.config

$(cliferay tomcat-folder)/bin/catalina.sh ${args["command"]:-jpda} run
