DB_NAME=$([[ "$(cliferay home)" =~ .*-ee$ ]] && echo "lportalee" || echo "lportal")
NAME=$(cat "$(cliferay bundles-folder)/.cliferay-name" 2>/dev/null || echo "master")

if [[ -n "$NAME" && "$NAME" != "master" ]]; then
  echo "${DB_NAME}_$NAME" | tr '-' '_' | tr '/' '_' | tr '.' '_'
else
  echo $DB_NAME
fi
