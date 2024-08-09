setup_file() {
    export TMP_DIR=/code/test/tmp
    rm -rf $TMP_DIR
    mkdir -p $TMP_DIR
    apk add git coreutils
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/mocks:$DIR/../bin:$PATH"
    git config --global --add safe.directory /code
    git config --global init.defaultBranch master
}

setup() {
    bats_require_minimum_version 1.5.0
    bats_load_library bats-support
    bats_load_library bats-assert
    bats_load_library bats-file
    export LIFERAY_HOME=$TMP_DIR/liferay/liferay-portal
    mkdir -p $LIFERAY_HOME
}

@test "cliferay" {
    run cliferay
    assert_line "cliferay - Daily scripts to work with Liferay"
}

@test "cliferay home" {
    run cliferay home
    assert_line $TMP_DIR/liferay/liferay-portal
    unset LIFERAY_HOME
    run cliferay home
    assert_output 'missing required environment variable: LIFERAY_HOME'
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

@test "cliferay folder" {
    run cliferay folder
    assert_output $TMP_DIR/liferay/liferay-portal
    mkdir -p $TMP_DIR/liferay-ee/liferay-portal-ee
    cd $TMP_DIR/liferay-ee/liferay-portal-ee
    git init
    run cliferay folder
    assert_output $TMP_DIR/liferay-ee/liferay-portal-ee
}

@test "cliferay db-name" {
    run cliferay db-name
    assert_output lportal
    mkdir -p $TMP_DIR/liferay-ee/liferay-portal-ee
    cd $TMP_DIR/liferay-ee/liferay-portal-ee
    run cliferay db-name
    assert_output lportalee
}

@test "cliferay ij" {
    run -127 cliferay ij
    assert_exists $TMP_DIR/liferay/liferay-intellij/.git
}
