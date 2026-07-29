setup_file() {
    export TMP_DIR="$TMPDIR/cliferay"
    rm -rf $TMP_DIR
    mkdir -p $TMP_DIR
    apk add git coreutils jq
    mkdir -p $TMP_DIR/mocks
    echo "#!/bin/sh" > $TMP_DIR/mocks/gh
    echo "#!/bin/sh" > $TMP_DIR/mocks/mysql
    chmod +x $TMP_DIR/mocks/*
    PATH="$TMP_DIR/mocks:/code/bin:$PATH"
    export CLIFERAY_DATA_FOLDER=$TMP_DIR/data
    mkdir -p $CLIFERAY_DATA_FOLDER
    git config --global --add safe.directory /code
    git config --global init.defaultBranch master
}

setup() {
    bats_require_minimum_version 1.5.0
    bats_load_library bats-assert
    bats_load_library bats-file
    bats_load_library bats-support
    export LIFERAY_HOME=$TMP_DIR/liferay/liferay-portal
    mkdir -p $LIFERAY_HOME
}

setup_run() {
    export LIFERAY_HOME=$TMP_DIR/run/liferay-portal
    export BUNDLES=$TMP_DIR/run/bundles
    export PROPS=$BUNDLES/portal-ext.properties
    rm -rf $TMP_DIR/run
    mkdir -p $LIFERAY_HOME $BUNDLES/tomcat-10.1.40/bin
    printf '#!/bin/sh\necho "CATALINA_OPTS=$CATALINA_OPTS"\nexit 0\n' > $BUNDLES/tomcat-10.1.40/bin/catalina.sh
    chmod +x $BUNDLES/tomcat-10.1.40/bin/catalina.sh
    cd $TMP_DIR/run
}

@test "cliferay" {
    run cliferay
    assert_line "cliferay - Daily scripts for working with Liferay"
}

@test "cliferay nuke" {
    mkdir -p $TMP_DIR/liferay/liferay-portal $TMP_DIR/liferay/bundles/elasticsearch7 $TMP_DIR/liferay/bundles/keep $TMP_DIR/liferay/bundles/data $TMP_DIR/liferay/bundles/osgi/war $TMP_DIR/liferay/bundles/osgi/state $TMP_DIR/liferay/bundles/osgi/keep
    export DEBUG=true
    run cliferay nuke
    assert_line "+ echo 'drop database IF EXISTS lportal; create database lportal CHARACTER SET utf8mb4 COLLATE utf8mb4_bin'"
    assert_exists $TMP_DIR/liferay/bundles/keep
    assert_exists $TMP_DIR/liferay/bundles/osgi/keep
    assert_not_exists $TMP_DIR/liferay/bundles/elasticsearch7
    assert_not_exists $TMP_DIR/liferay/bundles/data
    assert_not_exists $TMP_DIR/liferay/bundles/osgi/war
    assert_not_exists $TMP_DIR/liferay/bundles/osgi/state
}

@test "cliferay tomcat-folder" {
    mkdir -p $TMP_DIR/liferay/bundles/tomcat-9.0.83
    run cliferay tomcat-folder
    assert_output $TMP_DIR/liferay/bundles/tomcat-9.0.83

    mkdir -p $TMP_DIR/liferay/bundles/tomcat-9.0.87
    run cliferay tomcat-folder
    assert_output $TMP_DIR/liferay/bundles/tomcat-9.0.87

    mkdir -p $TMP_DIR/liferay/bundles/tomcat-9.0.90
    run cliferay tomcat-folder
    assert_output $TMP_DIR/liferay/bundles/tomcat-9.0.90

    mkdir -p $TMP_DIR/liferay/bundles/tomcat-10.1.40
    run cliferay tomcat-folder
    assert_output $TMP_DIR/liferay/bundles/tomcat-10.1.40
}

@test "cliferay owner" {
    cd $TMP_DIR/liferay/liferay-portal
    git init
    mkdir .github
    echo "
        a/ @team-a
        a/b/ @team-b
        a/c/
        d/
        d/e/ @team-a
        f/g/h/ @team-a
    " > .github/CODEOWNERS
    mkdir -p a/d/e
    cd a/d/e
    run cliferay owner
    assert_output @team-a
}

@test "cliferay tickets" {
    run bash -c 'echo "LPD-1234 Some text" | cliferay tickets'
    assert_output "https://liferay.atlassian.net/browse/LPD-1234"
}

@test "cliferay home" {
    run cliferay home
    assert_output $TMP_DIR/liferay/liferay-portal
    mkdir -p $TMP_DIR/liferay-ee/liferay-portal-ee
    cd $TMP_DIR/liferay-ee/liferay-portal-ee
    git init
    run cliferay home
    assert_output $TMP_DIR/liferay-ee/liferay-portal-ee
    unset LIFERAY_HOME
    run cliferay home
    assert_output 'missing required environment variable: LIFERAY_HOME'
}

@test "cliferay db-name/switch" {
    run cliferay db-name
    assert_output lportal

    cd $(cliferay home)
    mkdir -p ../bundles
    run cliferay db-name
    assert_output lportal
    cliferay switch test
    run cat ../bundles/.cliferay-name
    assert_output test
    run cat ../bundles-master/.cliferay-name
    assert_output master
    run cliferay db-name
    assert_output lportal_test
    cliferay switch master
    run cliferay db-name
    assert_output lportal
    run cat ../bundles/.cliferay-name
    assert_output master
    run cat ../bundles-test/.cliferay-name
    assert_output test

    mkdir -p $TMP_DIR/liferay-ee/liferay-portal-ee
    cd $TMP_DIR/liferay-ee/liferay-portal-ee
    run cliferay db-name
    assert_output lportalee
    mkdir -p ../bundles
    run cliferay db-name
    assert_output lportalee
    cliferay switch test
    run cliferay db-name
    assert_output lportalee_test
    cliferay switch master
    run cliferay db-name
    assert_output lportalee
}

@test "cliferay team users jira" {
    printf "user1 jiraid1 user1@example.com\nuser2 jiraid2 user2@example.com alt@user2.com\n" > $TMP_DIR/data/users

    run cliferay team users jira user1
    assert_output "jiraid1"

    run cliferay team users jira user2
    assert_output "jiraid2"
}

@test "cliferay team users emails" {
    printf "user1 jiraid1 email1@example.com\nuser2 jiraid2 email2@example.com email3@example.com\n" > $TMP_DIR/data/users

    run cliferay team users emails
    assert_line "email1@example.com"
    assert_line "email2@example.com"
    assert_line "email3@example.com"

    run cliferay team users emails user1
    assert_output "email1@example.com"

    run cliferay team users emails user2
    assert_line "email2@example.com"
    assert_line "email3@example.com"
}

@test "cliferay run-profiles" {
    run cliferay run-profiles
    assert_line "mcp"
    assert_line "mcp-oauth"
}

@test "cliferay run" {
    setup_run

    run cliferay run
    assert_success
    refute_output --partial 'liferay.mode=test'
    assert_exists $PROPS

    run grep -qx 'company.default.web.id=liferay.com' $PROPS
    assert_success

    assert_equal "$(tail -n 1 $PROPS)" 'include-and-override=${liferay.home}/portal-custom.properties'

    run grep -q '# Profile:' $PROPS
    assert_failure
    run grep -q 'feature.flag.LPD-63311' $PROPS
    assert_failure

    assert_exists $BUNDLES/osgi/configs/com.liferay.captcha.configuration.CaptchaConfiguration.config
    assert_not_exists $BUNDLES/osgi/configs/com.liferay.mcp.server.rest.internal.configuration.MCPServerConfiguration.config
}

@test "cliferay run --profile mcp" {
    setup_run

    run cliferay run --profile mcp
    assert_success
    refute_output --partial 'liferay.mode=test'
    assert_exists $PROPS

    run grep -qx '# Profile: mcp' $PROPS
    assert_success

    run grep -qx 'feature.flag.LPD-63311=true' $PROPS
    assert_success
    run grep -q 'web.server.host' $PROPS
    assert_failure

    assert_exists $BUNDLES/osgi/configs/com.liferay.mcp.server.rest.internal.configuration.MCPServerConfiguration.config
}

@test "cliferay run --profile mcp-oauth" {
    setup_run

    run cliferay run --profile mcp-oauth
    assert_success
    assert_output --partial '-Dliferay.mode=test'
    assert_exists $PROPS

    run grep -qx '# Profile: mcp-oauth' $PROPS
    assert_success

    run grep -qx 'feature.flag.LPD-63311=true' $PROPS
    assert_success
    run grep -qx 'feature.flag.LPD-63415=true' $PROPS
    assert_success
    run grep -qx 'feature.flag.LPD-63416=true' $PROPS
    assert_success
    run grep -q 'web.server.host' $PROPS
    assert_failure

    run bash -c "grep -A 1 '# Profile: mcp-oauth' $PROPS | tail -n 1"
    assert_output ''

    assert_equal "$(tail -n 1 $PROPS)" 'include-and-override=${liferay.home}/portal-custom.properties'

    assert_exists $BUNDLES/osgi/configs/com.liferay.captcha.configuration.CaptchaConfiguration.config
    assert_exists $BUNDLES/osgi/configs/com.liferay.mcp.server.rest.internal.configuration.MCPServerConfiguration.config
    assert_exists $BUNDLES/osgi/configs/com.liferay.portal.remote.cors.configuration.PortalCORSConfiguration~default.config
    assert_exists $BUNDLES/osgi/configs/com.liferay.oauth2.provider.rest.internal.configuration.OAuth2DynamicRegistrationConfiguration.config
}

@test "cliferay run --profile nope" {
    setup_run

    run cliferay run --profile nope
    assert_failure
    assert_line "Unknown run profile: nope"
    assert_line --partial "mcp-oauth"
}

@test "cliferay run -p mcp-oauth" {
    setup_run

    run cliferay run -p mcp-oauth
    assert_success
    run grep -qx '# Profile: mcp-oauth' $PROPS
    assert_success
}
