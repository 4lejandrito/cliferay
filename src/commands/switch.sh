BUNDLES=$(cliferay bundles-folder)
CURRENT_NAME=$(cat "$BUNDLES/.cliferay-name" 2>/dev/null || echo master)
if [[ "$CURRENT_NAME" == "${args[name]}" ]]; then
  return
fi
(cliferay kill)
echo "$CURRENT_NAME" > "$BUNDLES/.cliferay-name"
mv "$BUNDLES" "$BUNDLES-$CURRENT_NAME"
if [ ! -d "$BUNDLES-${args[name]}" ]; then
  cp -r "$BUNDLES-$CURRENT_NAME" "$BUNDLES"
  echo "${args[name]}" > "$BUNDLES/.cliferay-name"
  cliferay nuke
else
  mv "$BUNDLES-${args[name]}" "$BUNDLES"
fi
