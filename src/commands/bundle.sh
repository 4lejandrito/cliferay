
BASE_URL="https://releases.liferay.com/${args["version"]}"
FOLDER=$(cliferay data-folder)/bundles/${args["version"]}
mkdir -p "$FOLDER"
(
    ZIP_FILE=$(curl -s "$BASE_URL/" | grep -ioE 'liferay[^"'\'' >]*tomcat[^"'\'' >]*\.zip"' | head -n1)
    TAR_FILE=$(curl -s "$BASE_URL/" | grep -ioE 'liferay[^"'\'' >]*tomcat[^"'\'' >]*\.tar.gz"' | head -n1)
    ZIP_FILE=${ZIP_FILE%?}
    TAR_FILE=${TAR_FILE%?}
    cd "$FOLDER"
    if [ -n "$ZIP_FILE" ]; then
        if [ ! -f "$ZIP_FILE" ]; then
            curl -O "$BASE_URL/$ZIP_FILE"
            unzip -q "$ZIP_FILE"
        fi
        FILE="$ZIP_FILE"
    elif [ -n "$TAR_FILE" ]; then
        if [ ! -f "$TAR_FILE" ]; then
            curl -O "$BASE_URL/$TAR_FILE"
            tar -xzf "$TAR_FILE"
        fi
        FILE="$TAR_FILE"
    fi
)
cliferay switch "${args["name"]}"
rm -rf $(cliferay home)/../bundles
cp -r "$(find "$FOLDER" -maxdepth 1 -type d -name 'liferay-*' | head -n1)" $(cliferay home)/../bundles
deploy_activation_key $(cliferay home)/../bundles
cd $(cliferay home)
GITHASH=$(cat ../bundles/.githash)
echo "${args["version"]}" > ../bundles/.cliferay-name
git fetch --depth=1 upstream $GITHASH && git checkout $GITHASH
cliferay ij