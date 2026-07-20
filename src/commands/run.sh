PROFILE="${args[--profile]:-}"

if [ -n "$PROFILE" ]; then
    PROFILE_DIR=$(cliferay source-folder)/src/run-profiles/$PROFILE
    if [ ! -d "$PROFILE_DIR" ]; then
        echo "Unknown run profile: $PROFILE" >&2
        echo "Available profiles:" >&2
        cliferay run-profiles | sed 's/^/  /' >&2
        exit 1
    fi
fi

function generate-configuration() {
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

liferay.home=$1

setup.wizard.enabled=false
terms.of.use.required=false
passwords.default.policy.change.required=false
passwords.encryption.algorithm=NONE
users.reminder.queries.required=false
users.reminder.queries.enabled=false
enterprise.product.notification.enabled=false

feature.flag.ui.visible[dev]=true

module.framework.properties.osgi.console=11311

virtual.hosts.valid.hosts=localhost,127.0.0.1,www.able.com,[0:0:0:0:0:0:0:1]
" > $1/portal-ext.properties

if [ -n "$PROFILE" ] && [ -f "$PROFILE_DIR/portal-ext.properties" ]; then
    echo "" >> $1/portal-ext.properties
    echo "# Profile: $PROFILE" >> $1/portal-ext.properties
    echo "" >> $1/portal-ext.properties
    cat "$PROFILE_DIR/portal-ext.properties" >> $1/portal-ext.properties
fi

echo "" >> $1/portal-ext.properties
echo "include-and-override=\${liferay.home}/portal-custom.properties" >> $1/portal-ext.properties

sed -i 's/^[[:space:]]*//' $1/portal-ext.properties

if [ ! -f "$1/portal-custom.properties" ]; then
    echo "# Override your config here, don't touch portal-ext.properties" > $1/portal-custom.properties
fi
mkdir -p $1/osgi/configs
echo 'maxChallenges=I"-1"' > $1/osgi/configs/com.liferay.captcha.configuration.CaptchaConfiguration.config

# Layer the run profile OSGi configs on top of the shared baseline.
if [ -n "$PROFILE" ] && [ -d "$PROFILE_DIR/osgi/configs" ]; then
    cp "$PROFILE_DIR/osgi/configs/"*.config $1/osgi/configs/
fi
}

BUNDLES=$(realpath $(cliferay home)/../bundles)

generate-configuration $BUNDLES

if [ -n "$PROFILE" ] && [ -f "$PROFILE_DIR/catalina-opts" ]; then
    PROFILE_OPTS=$(grep -v '^[[:space:]]*#' "$PROFILE_DIR/catalina-opts" | tr '\n' ' ')
    export CATALINA_OPTS="${CATALINA_OPTS:-} $PROFILE_OPTS"
fi

$(cliferay tomcat-folder)/bin/catalina.sh ${args["command"]:-jpda} run
