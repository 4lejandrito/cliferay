HOST=${args["host"]}
liferay-curl -X 'POST' \
  'http://localhost:8080/o/headless-portal-instances/v1.0/portal-instances' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "domain": "liferay.com",
  "portalInstanceId": "'$HOST'",
  "virtualHost": "'$HOST'"
}'