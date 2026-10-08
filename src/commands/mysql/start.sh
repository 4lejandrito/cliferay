if mysql-container-running; then
    echo "The $MYSQL_CONTAINER container is already running"
    exit
fi

if ! mysql-container-exists; then
    cliferay mysql create
    exit
fi

mysql-port-free

docker start "$MYSQL_CONTAINER"

mysql-wait

echo "MySQL is ready on localhost:3306 (user root, password root)"
