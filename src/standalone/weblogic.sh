#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: run.sh <product/version>"
	echo "  e.g. run.sh dxp/2025.q1.12-lts"
	exit 1
fi

LIFERAY_RELEASE_URL="https://releases.liferay.com/$1"
LIFERAY_VERSION=$(basename "$1")

echo "Downloading Liferay files..."

if ! ls liferay-dxp-"$LIFERAY_VERSION"*.war 1>/dev/null 2>&1; then
	WAR_FILE=$(curl -sL "$LIFERAY_RELEASE_URL/" | grep -oP "liferay-dxp-${LIFERAY_VERSION}[^\"]*\.war" | head -1)
	curl -LO "$LIFERAY_RELEASE_URL/$WAR_FILE"
fi

if ! ls liferay-dxp-osgi-"$LIFERAY_VERSION"*.zip 1>/dev/null 2>&1; then
	OSGI_FILE=$(curl -sL "$LIFERAY_RELEASE_URL/" | grep -oP "liferay-dxp-osgi-${LIFERAY_VERSION}[^\"]*\.zip" | head -1)
	curl -LO "$LIFERAY_RELEASE_URL/$OSGI_FILE"
fi

echo "Setting up JDK 17..."

if [ ! -d "jdk-17.0.12" ]; then
	if [ ! -f "jdk-17.0.12_linux-x64_bin.tar.gz" ]; then
		curl -LO https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz
	fi
	tar -xzf jdk-17.0.12_linux-x64_bin.tar.gz
fi

echo "Setting up WebLogic installer..."

if [ ! -f "fmw_14.1.2.0.0_wls.jar" ]; then
	if [ ! -f "V1045131-01.zip" ]; then
		echo "$PWD/V1045131-01.zip not found. Download it from https://drive.google.com/file/d/1LmGPkRBi8BqVnGEx_D9WSLDMZ3OEDAnn/view"
		exit 1
	fi
	unzip -o V1045131-01.zip
fi

ORACLE_HOME="$PWD/oracle/Oracle_Home"
ORA_INVENTORY="$PWD/oracle/oraInventory"
OUTPUT_RSP="$PWD/liferay.rsp"

cat > "$OUTPUT_RSP" << EOF
[ENGINE]
Response File Version=1.0.0.0.0

[GENERIC]
ORACLE_HOME=${ORACLE_HOME}
INSTALL_TYPE=WebLogic Server
DECLINE_SECURITY_UPDATES=true
EOF

cat > "$PWD/oraInst.loc" << EOF
inventory_loc=${ORA_INVENTORY}
inst_group=$(id -gn)
EOF


echo "Installing WebLogic Server..."

JAVA_HOME="$PWD/jdk-17.0.12" PATH="$PWD/jdk-17.0.12/bin:$PATH" java -jar fmw_*.jar -silent -ignoreSysPrereqs -responseFile "$OUTPUT_RSP" -invPtrLoc "$PWD/oraInst.loc"

DOMAIN_HOME="$ORACLE_HOME/user_projects/domains/liferay"

echo "Creating liferay domain..."

cat > "$PWD/create_domain.py" << EOF
readTemplate('$ORACLE_HOME/wlserver/common/templates/wls/wls.jar')
cd('Servers/AdminServer')
set('ListenAddress', '')
set('ListenPort', 7001)
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setPassword('weblogic1')
setOption('OverwriteDomain', 'true')
setOption('ServerStartMode', 'dev')
writeDomain('$DOMAIN_HOME')
EOF

"$ORACLE_HOME/oracle_common/common/bin/wlst.sh" -skipWLSModuleScanning "$PWD/create_domain.py" > /dev/null

echo "Extracting liferay-dxp-osgi..."

unzip -o liferay-dxp-osgi*.zip -d "$ORACLE_HOME/user_projects/domains"

echo "Installing WAR..."

mkdir -p "$DOMAIN_HOME/autodeploy"
cp liferay-dxp*.war "$DOMAIN_HOME/autodeploy/"

echo "Copying activation key..."

if ls activation-key-*.xml 1>/dev/null 2>&1; then
	mkdir -p "$ORACLE_HOME/user_projects/domains/deploy"
	cp activation-key-*.xml "$ORACLE_HOME/user_projects/domains/deploy/"
fi

echo "Configuring setUserOverridesLate.sh..."

mkdir -p "$DOMAIN_HOME/bin"

cat > "$DOMAIN_HOME/bin/setUserOverridesLate.sh" << 'EOF'
export DERBY_FLAG="false"

export JAVA_OPTIONS="${JAVA_OPTIONS} -Dfile.encoding=UTF-8 -Djava.locale.providers=JRE,COMPAT,CLDR -Djava.net.preferIPv4Stack=true -Dlog4j2.formatMsgNoLookups=true -Duser.timezone=GMT -da:org.apache.lucene... -da:org.aspectj..."

export JAVA_OPTIONS="${JAVA_OPTIONS} --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.util.concurrent=ALL-UNNAMED --add-opens=java.base/sun.util.calendar=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.base/sun.security.ssl=ALL-UNNAMED --add-opens=java.base/sun.security.util=ALL-UNNAMED --add-opens=java.management/javax.management=ALL-UNNAMED --add-opens=java.naming/javax.naming=ALL-UNNAMED"

export JAVA_PROPERTIES="-Dfile.encoding=UTF-8 ${JAVA_PROPERTIES} ${CLUSTER_PROPERTIES}"
EOF

cat >> "$DOMAIN_HOME/bin/setUserOverridesLate.sh" << EOF

export MW_HOME="$ORACLE_HOME/wlserver"

export USER_MEM_ARGS="-Xms2560m -Xmx2560m -XX:MaxNewSize=1536m -XX:MaxMetaspaceSize=768m -XX:MetaspaceSize=768m -XX:NewSize=1536m -XX:SurvivorRatio=7"
EOF

chmod +x "$DOMAIN_HOME/bin/setUserOverridesLate.sh"

echo "Configuring nodemanager.properties..."

sed -i 's/NativeVersionEnabled=true/NativeVersionEnabled=false/' "$DOMAIN_HOME/nodemanager/nodemanager.properties"

echo "Configuring portal-ext.properties..."

cat > "$ORACLE_HOME/user_projects/domains/portal-ext.properties" << 'EOF'
admin.email.from.address=test@liferay.com
admin.email.from.name=Test Test
company.default.locale=en_US
company.default.time.zone=UTC
company.default.web.id=liferay.com
default.admin.email.address.prefix=test
setup.wizard.enabled=false
captcha.enforce.disabled=true
terms.of.use.required=false
passwords.default.policy.change.required=false
passwords.encryption.algorithm=NONE
users.reminder.queries.required=false
users.reminder.queries.enabled=false
enterprise.product.notification.enabled=false
feature.flag.ui.visible[dev]=true
module.framework.properties.osgi.console=11312
EOF

echo "Configuring Elasticsearch sidecar..."

mkdir -p "$ORACLE_HOME/user_projects/domains/osgi/configs"

cat > "$ORACLE_HOME/user_projects/domains/osgi/configs/com.liferay.portal.search.elasticsearch7.configuration.ElasticsearchConfiguration.config" << 'EOF'
sidecarJVMOptions=[ \
  "-Xms1g", \
  "-Xmx1g", \
  "-XX:+AlwaysPreTouch", \
  "--add-opens\=java.base/java.lang\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.lang.invoke\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.lang.reflect\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.io\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.net\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.nio\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.util\=ALL-UNNAMED", \
  "--add-opens\=java.base/java.util.concurrent\=ALL-UNNAMED", \
  "--add-opens\=java.base/sun.util.calendar\=ALL-UNNAMED", \
  "--add-opens\=java.base/sun.nio.ch\=ALL-UNNAMED", \
  "--add-opens\=java.base/sun.security.ssl\=ALL-UNNAMED", \
  "--add-opens\=java.base/sun.security.util\=ALL-UNNAMED", \
  "--add-opens\=java.management/javax.management\=ALL-UNNAMED", \
  "--add-opens\=java.naming/javax.naming\=ALL-UNNAMED", \
]
EOF

echo "Starting WebLogic server..."

JAVA_HOME="$PWD/jdk-17.0.12" PATH="$PWD/jdk-17.0.12/bin:$PATH" JAVA_OPTIONS="${JAVA_OPTIONS} -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" "$DOMAIN_HOME/startWebLogic.sh"
