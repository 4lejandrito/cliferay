BASE_URL="https://releases.liferay.com/${args["version"]}"
FILE=$(curl -s "$BASE_URL/" | grep -ioE 'liferay[^"'\'' >]*tomcat[^"'\'' >]*\.tar.gz' | head -n1)
FOLDER=$(cliferay data-folder)/bundles/${args["version"]}
mkdir -p "$FOLDER"
(
    cd "$FOLDER"
    if [ ! -f "$FILE" ]; then
        curl -O "$BASE_URL/$FILE"
        tar -xzf "$FILE"
    fi
)
rm -rf $(cliferay home)/../bundles
cp -r "$(find "$FOLDER" -maxdepth 1 -type d -name 'liferay-*' | head -n1)" $(cliferay home)/../bundles
deploy_activation_key $(cliferay home)/../bundles
cd $(cliferay home)
GITHASH=$(cat ../bundles/.githash)
git fetch --depth=1 upstream $GITHASH && git checkout $GITHASH
cliferay ij