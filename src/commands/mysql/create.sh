if mysql-container-exists; then
    echo "The $MYSQL_CONTAINER container already exists. Run 'cliferay mysql start' to start it or 'cliferay mysql remove' to recreate it." >&2
    exit 1
fi

DB_NAME=$(cliferay db-name)

docker run --name "$MYSQL_CONTAINER" -d \
    -e MYSQL_ROOT_PASSWORD=root \
    -p 127.0.0.1:3306:3306 \
    -v "$MYSQL_CONTAINER:/var/lib/mysql" \
    "mysql:${args[version]}" \
    --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

mysql-wait

echo "create database IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_bin" | mysql-client

echo "MySQL is ready on localhost:3306 (user root, password root) with the $DB_NAME database"
