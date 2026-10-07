HOME_FOLDER=$(cliferay home)

if [ -n "${CLIFERAY_BUNDLES_FOLDER:-}" ]; then
    echo "$CLIFERAY_BUNDLES_FOLDER"
    exit
fi

# The Liferay build reads app.server.${user.name}.properties on top of
# app.server.properties, so honoring the same file keeps cliferay and ant
# pointing at the same bundle.
PROPERTIES="$HOME_FOLDER/app.server.$(id -un).properties"

if [ -f "$PROPERTIES" ]; then
    PARENT_DIR=$(grep -E '^[[:space:]]*app\.server\.parent\.dir[[:space:]]*=' "$PROPERTIES" | tail -n 1 | cut -d= -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [ -n "$PARENT_DIR" ]; then
        echo "${PARENT_DIR//\$\{project.dir\}/$HOME_FOLDER}"
        exit
    fi
fi

echo "$HOME_FOLDER/../bundles"
