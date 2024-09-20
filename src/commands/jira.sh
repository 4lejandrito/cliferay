TICKETS=$(echo "${args["ticket"]:-$(git rev-parse --abbrev-ref HEAD)}" | cliferay tickets)
if [ -n "$TICKETS" ]; then
    echo "$TICKETS" | xargs npx -y open-cli
else
    cliferay jira --help
fi