get_current_period

JQL="assignee was $(cliferay stats users jira ${args["user"]}) during (${since%%T*}, ${until%%T*}) AND project IS NOT EMPTY AND issue in updatedBy($(cliferay stats users jira ${args["user"]}), "${since%%T*}", "${until%%T*}") ORDER BY updated DESC"

curl -s -u "$JIRA_API_USER:$JIRA_API_TOKEN" \
    -H "Accept: application/json" \
    "https://liferay.atlassian.net/rest/api/3/search/jql?jql=$(printf '%s' "$JQL" | jq -sRr @uri)&fields=key" \
    | jq -r '.issues[].key' \
    | cliferay tickets
