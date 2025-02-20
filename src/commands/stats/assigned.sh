get_current_period
jira issue list -q "assignee was $(cliferay stats users jira ${args["user"]}) during ($since, $until) AND project IS NOT EMPTY" | cliferay tickets
