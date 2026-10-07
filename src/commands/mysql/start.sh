if ! mysql-container-exists; then
    echo "The $MYSQL_CONTAINER container does not exist. Run 'cliferay mysql create' first." >&2
    exit 1
fi

docker start "$MYSQL_CONTAINER"

mysql-wait

echo "MySQL is ready on localhost:3306 (user root, password root)"
