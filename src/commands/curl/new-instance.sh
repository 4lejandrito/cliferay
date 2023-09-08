HOST=${args["host"]}
curl --no-progress-meter -X 'POST' \
  'http://localhost:8080/o/headless-portal-instances/v1.0/portal-instances' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "domain": "'$HOST'",
  "portalInstanceId": "'$HOST'",
  "virtualHost": "'$HOST'"
}' \
-u 'test@liferay.com:test' | jq