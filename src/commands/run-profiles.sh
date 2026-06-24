PROFILES_DIR=$(cliferay source-folder)/src/run-profiles

if [ -d "$PROFILES_DIR" ]; then
    for profile in "$PROFILES_DIR"/*/; do
        [ -d "$profile" ] && basename "$profile"
    done
fi
