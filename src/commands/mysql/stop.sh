if ! mysql-container-exists; then
    echo "The $MYSQL_CONTAINER container does not exist." >&2
    exit 1
fi

docker stop "$MYSQL_CONTAINER"
