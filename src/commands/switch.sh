cd $(cliferay home)
CURRENT_NAME=$(cat ../bundles/.cliferay-name 2>/dev/null || echo master)
if [[ "$CURRENT_NAME" == "${args[name]}" ]]; then
  return
fi
(cliferay kill)
echo "$CURRENT_NAME" > ../bundles/.cliferay-name
mv ../bundles "../bundles-$CURRENT_NAME"
if [ ! -d "../bundles-${args[name]}" ]; then
  cp -r "../bundles-$CURRENT_NAME" ../bundles
  echo "${args[name]}" > ../bundles/.cliferay-name
  cliferay nuke
else
  mv "../bundles-${args[name]}" ../bundles
fi