function get-module() {
	while read line
	do
		if test -f $line/bnd.bnd; then
			echo "$line";
		elif [ "$line" != "." ]; then
			(dirname $line | get-module)
		fi
	done
}

function run-stdin() {
	set +e
	while read line
	do
		echo "" | (cd $(cliferay home)/$line; $*)
	done
	set -e
}

function liferay-curl() {
	curl --no-progress-meter -u 'test@liferay.com:test' "$@" | jq
}

function get_current_period() {
    current_year=$(date -u '+%Y')
    month=$(date -u '+%m')

    if [ -n "$Q" ]; then
        current_year=$(echo "$Q" | cut -d'-' -f1)
        quarter=$(echo "$Q" | cut -d'-' -f2 | tr -d 'q')
        case $quarter in
            1)
                since="${current_year}-01-01T00:00:00Z"
                until="${current_year}-04-01T00:00:00Z"
                ;;
            2)
                since="${current_year}-04-01T00:00:00Z"
                until="${current_year}-07-01T00:00:00Z"
                ;;
            3)
                since="${current_year}-07-01T00:00:00Z"
                until="${current_year}-10-01T00:00:00Z"
                ;;
            4)
                since="${current_year}-10-01T00:00:00Z"
                until="$(($current_year + 1))-01-01T00:00:00Z"
                ;;
            *)
                echo "Invalid quarter specified. Use format yyyy-qx (e.g., 2023-q1)."
                return 1
                ;;
        esac
    else
        since="2000-01-01T00:00:00Z"
        until="${current_year}-12-31T23:59:59Z"
    fi
}

function get_git_log_period() {
    get_current_period
    echo "--since=\"$since\" --until=\"$until\""
}

function deploy_activation_key() {
    mkdir -p $1/deploy
    cp $(cliferay data-folder)/activation-* $1/deploy/ 2>/dev/null || true
}

# Locate a GNU sed and expose it as $SED.
#
# This follows the Autoconf convention (AC_PROG_SED sets the SED output
# variable) that Kubernetes also uses in kube::util::ensure-gnu-sed.
#
# BSD sed, which is what macOS ships, is not a drop-in replacement for GNU sed:
# -i requires a backup suffix argument there, and GNU regex extensions such as
# \s or \+ silently match nothing instead of failing.
#
#     ensure-gnu-sed
#
#     $SED -i 's/foo/bar/' "$file"
function ensure-gnu-sed() {
    if sed --version 2>/dev/null | grep -q GNU; then
        SED=sed
    elif command -v gsed >/dev/null 2>&1; then
        SED=gsed
    else
        echo "Failed to find GNU sed as sed or gsed." >&2
        echo "On macOS: brew install gnu-sed" >&2
        exit 1
    fi
}

# The MySQL Docker container managed by 'cliferay mysql'.
#
# It listens on localhost:3306 with root/root, which is what 'cliferay run'
# writes into portal-ext.properties, so the server works against it unchanged.
MYSQL_CONTAINER=cliferay-mysql

function mysql-container-exists() {
    command -v docker >/dev/null 2>&1 && docker container inspect "$MYSQL_CONTAINER" >/dev/null 2>&1
}

function mysql-container-running() {
    command -v docker >/dev/null 2>&1 && [ "$(docker container inspect -f '{{.State.Running}}' "$MYSQL_CONTAINER" 2>/dev/null)" == "true" ]
}

# Run the mysql client as root against the Liferay database server.
#
# Goes through the 'cliferay mysql' container when it is running, so no local
# mysql client is needed, and falls back to a local one otherwise.
#
#     echo "SELECT 1" | mysql-client lportal
function mysql-client() {
    if mysql-container-running; then
        docker exec -i "$MYSQL_CONTAINER" mysql -uroot -proot "$@"
    else
        mysql -uroot -proot "$@"
    fi
}

# Block until the 'cliferay mysql' container accepts TCP connections.
#
# The ping goes over TCP on purpose: while the mysql image initializes a fresh
# data directory it runs a temporary server on the socket only, and a socket
# ping would report ready too early.
function mysql-wait() {
    for _ in $(seq 1 60); do
        if docker exec "$MYSQL_CONTAINER" mysqladmin ping -h127.0.0.1 --protocol=tcp -uroot -proot --silent >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done
    echo "Timed out waiting for the $MYSQL_CONTAINER container to accept connections" >&2
    return 1
}

# Make sure a MySQL server is listening on localhost:3306 before commands that
# need one, such as 'cliferay morning'.
#
# Does nothing when the 'cliferay mysql' container is running or when another
# server, like a local install, already listens on the port. Otherwise it
# starts the container, creating it first if needed.
function mysql-up() {
    if mysql-container-running; then
        return
    fi
    if (exec 3<>/dev/tcp/127.0.0.1/3306) 2>/dev/null; then
        return
    fi
    cliferay mysql start
}
