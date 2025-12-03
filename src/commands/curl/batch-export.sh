TASK_ID=$(liferay-curl -X POST -H "Content-Type: application/json" "http://localhost:8080/o/headless-admin-site/v1.0/sites/L_GUEST/site-pages/export-batch?batchNestedFields=pageSpecifications" | jq -r '.id')
sleep 1
curl -u test@liferay.com:test -X GET -H "Content-Type: application/json" \
    "http://localhost:8080/o/headless-batch-engine/v1.0/export-task/$TASK_ID/content" \
    --output export-content.zip
unzip -p export-content.zip $(unzip -l export-content.zip | awk '/.json$/ {print $4; exit}') | jq .
rm -rf export-content.zip