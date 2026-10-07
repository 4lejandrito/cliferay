if mysql-container-exists; then
    docker rm -f "$MYSQL_CONTAINER"
else
    echo "The $MYSQL_CONTAINER container does not exist." >&2
fi

if [[ ${args[--keep-data]} != 1 ]] && docker volume inspect "$MYSQL_CONTAINER" >/dev/null 2>&1; then
    docker volume rm "$MYSQL_CONTAINER"
fi
