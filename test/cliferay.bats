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
    mkdir -p $TMP_DIR/liferay/liferay-portal $TMP_DIR/liferay/bundles/elasticsearch-sidecar $TMP_DIR/liferay/bundles/keep $TMP_DIR/liferay/bundles/data $TMP_DIR/liferay/bundles/osgi/war $TMP_DIR/liferay/bundles/osgi/state $TMP_DIR/liferay/bundles/osgi/keep
    export DEBUG=true
    run cliferay nuke
    assert_line "+ echo 'drop database IF EXISTS lportal; create database lportal CHARACTER SET utf8mb4 COLLATE utf8mb4_bin'"
    assert_exists $TMP_DIR/liferay/bundles/keep
    assert_exists $TMP_DIR/liferay/bundles/osgi/keep
    assert_exists $TMP_DIR/liferay/bundles/elasticsearch-sidecar
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

@test "cliferay todo/todos" {
    export CLIFERAY_DATA_FOLDER=$TMP_DIR/todos
    rm -rf $CLIFERAY_DATA_FOLDER
    mkdir -p $CLIFERAY_DATA_FOLDER

    run cliferay todo Review PR https://github.com/liferay/liferay-portal/pull/1
    assert_success
    assert_output "$CLIFERAY_DATA_FOLDER/todo/todo/001-review-pr/todo.md"

    run cat $output
    assert_line 'links:'
    assert_line '  - https://github.com/liferay/liferay-portal/pull/1'
    assert_line '# Review PR'

    # A new todo goes first and pushes the rest down.
    run cliferay todo Review PR
    assert_success
    assert_output --partial "/001-review-pr/todo.md"
    assert_exists $CLIFERAY_DATA_FOLDER/todo/todo/002-review-pr

    run cliferay todo "Review Alex's PR"
    assert_success
    assert_output --partial "/001-review-alex-s-pr/todo.md"
    run cat $output
    assert_line "# Review Alex's PR"

    run cliferay todos
    assert_success
    assert_line --index 0 --partial "001-review-alex-s-pr/todo.md Review Alex's PR"
    assert_line --index 1 --partial "002-review-pr/todo.md Review PR"
    assert_line --index 2 --partial "003-review-pr/todo.md Review PR"

    mv $CLIFERAY_DATA_FOLDER/todo/todo/003-review-pr $CLIFERAY_DATA_FOLDER/todo/todo/000-review-pr
    run cliferay todos
    assert_line --index 0 --partial "000-review-pr/todo.md Review PR"

    run cliferay todo Another one
    assert_success
    assert_output --partial "/001-another-one/todo.md"
    assert_exists $CLIFERAY_DATA_FOLDER/todo/todo/002-review-pr
    assert_exists $CLIFERAY_DATA_FOLDER/todo/todo/003-review-alex-s-pr
    assert_exists $CLIFERAY_DATA_FOLDER/todo/todo/004-review-pr
}

@test "cliferay todos tui" {
    export CLIFERAY_DATA_FOLDER=$TMP_DIR/tui
    rm -rf $CLIFERAY_DATA_FOLDER
    mkdir -p $CLIFERAY_DATA_FOLDER
    # Each new todo goes first, so add them backwards to get First, Second, Third.
    cliferay todo Third one
    cliferay todo Second one
    cliferay todo First one

    TODO=$CLIFERAY_DATA_FOLDER/todo/todo
    DONE=$CLIFERAY_DATA_FOLDER/todo/done

    # Shift+down demotes the top todo, shift+up promotes it back.
    printf '\033[1;2Bq' | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null
    assert_exists $TODO/001-second-one
    assert_exists $TODO/002-first-one
    printf '\033[B\033[1;2Aq' | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null
    assert_exists $TODO/001-first-one
    assert_exists $TODO/002-second-one

    # Plain arrows still just move the selection.
    printf '\033[B\033[Bq' | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null
    assert_exists $TODO/001-first-one
    assert_exists $TODO/003-third-one

    # Send the second todo to the top.
    printf 'jtq' | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null
    assert_exists $TODO/001-second-one
    assert_exists $TODO/002-first-one

    # Complete the top todo: it moves to done and the rest close the gap.
    printf 'dq' | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null
    assert_not_exists $TODO/001-second-one
    assert_exists $TODO/001-first-one
    assert_exists $TODO/002-third-one
    assert_equal "$(ls $DONE | wc -l)" 1
    run bash -c "ls $DONE"
    assert_output --regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}-second-one$'

    # The same key reopens it, always landing on Todo with the item first.
    run bash -c "{ printf '\\033[C'; sleep 0.4; printf 'd'; sleep 0.6; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'"
    assert_output --partial "Reopened: Second one"
    assert_output --partial "▸ Second one"
    assert_equal "$(ls $DONE | wc -l)" 0
    assert_exists $TODO/001-second-one
    assert_exists $TODO/002-first-one
    assert_exists $TODO/003-third-one

    # Enter opens the reader, q returns to the list.
    run bash -c "{ printf '\\n'; sleep 0.4; printf 'q'; sleep 0.4; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos"
    assert_output --partial "# Second one"
    assert_output --partial "created:"
    assert_output --partial "scroll"

    # From the reader, d completes the todo and drops back to the list.
    run bash -c "{ printf '\\n'; sleep 0.4; printf 'd'; sleep 0.6; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'"
    assert_output --partial "d done"
    assert_equal "$(ls $DONE | wc -l)" 1
    assert_not_exists $TODO/001-second-one
    assert_exists $TODO/001-first-one
    assert_exists $TODO/002-third-one
    run bash -c "ls $DONE"
    assert_output --regexp '\-second-one$'

    # f forgets the top todo: it lands in forgotten and the rest close the gap.
    FORGOTTEN=$CLIFERAY_DATA_FOLDER/todo/forgotten
    printf 'fq' | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null
    assert_not_exists $TODO/002-third-one
    assert_exists $TODO/001-third-one
    assert_equal "$(ls $FORGOTTEN | wc -l)" 1
    run bash -c "ls $FORGOTTEN"
    assert_output --regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}-first-one$'

    # d on the forgotten tab brings it back as the most important todo.
    run bash -c "{ printf '\\033[C\\033[C'; sleep 0.4; printf 'd'; sleep 0.6; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'"
    assert_output --partial "Reopened: First one"
    assert_equal "$(ls $FORGOTTEN | wc -l)" 0
    assert_exists $TODO/001-first-one
    assert_exists $TODO/002-third-one

    # From the reader, f forgets and drops back to the list.
    run bash -c "{ printf '\\n'; sleep 0.4; printf 'f'; sleep 0.6; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'"
    assert_output --partial "f forget"
    assert_equal "$(ls $FORGOTTEN | wc -l)" 1
    assert_exists $TODO/001-third-one
    run bash -c "ls $FORGOTTEN"
    assert_output --regexp '\-first-one$'

    # Bring it back so the listing below is unchanged.
    run bash -c "{ printf '\\033[C\\033[C'; sleep 0.4; printf 'd'; sleep 0.6; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos > /dev/null"
    assert_exists $TODO/001-first-one
    assert_exists $TODO/002-third-one

    # A link too long for the pane keeps its exact target in an OSC 8 escape,
    # so it stays clickable however narrow the terminal is.
    LINK="https://liferay.atlassian.net/wiki/spaces/PEDS/pages/4714758579/A Very Long Page Name?atlOrigin=eyJpIjoiY2I4YTE2YTUy"
    printf '%s\n' '---' 'links:' "  - $LINK" '---' '' '# First one' > $TODO/001-first-one/todo.md
    run bash -c "{ printf '\\n'; sleep 0.4; printf 'q'; sleep 0.4; printf 'q'; } | CLIFERAY_TODOS_TUI=1 cliferay todos"
    assert_output --partial "$(printf '\033]8;;')${LINK// /%20}$(printf '\033\\')"
    assert_output --partial "…"

    # Piped output stays the plain listing.
    run cliferay todos
    assert_line --index 0 --partial "001-first-one/todo.md First one"
    assert_equal "${#lines[@]}" 2
}

@test "cliferay todo commits to the data repository" {
    export CLIFERAY_DATA_FOLDER=$TMP_DIR/todos-git
    rm -rf $CLIFERAY_DATA_FOLDER
    mkdir -p $CLIFERAY_DATA_FOLDER
    git -C $CLIFERAY_DATA_FOLDER init -q
    git -C $CLIFERAY_DATA_FOLDER config user.email test@liferay.com
    git -C $CLIFERAY_DATA_FOLDER config user.name Test

    run cliferay todo Complete the milestone
    assert_success
    assert_output --partial "Could not push"

    run git -C $CLIFERAY_DATA_FOLDER log --oneline
    assert_output --partial "Todo: Complete the milestone"

    run git -C $CLIFERAY_DATA_FOLDER status --porcelain
    assert_output ""
}
