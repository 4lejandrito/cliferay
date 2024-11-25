TICKETS=$(echo "${args["ticket"]:-$(git rev-parse --abbrev-ref HEAD)}" | cliferay tickets)
if [ -n "$TICKETS" ]; then
    echo "$TICKETS" | xargs python3 -m webbrowser
else
    cliferay jira --help
fi