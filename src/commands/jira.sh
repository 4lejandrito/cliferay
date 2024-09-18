TICKET=${args["ticket"]:-$(git rev-parse --abbrev-ref HEAD | grep -oE 'LP[A-Z]-[0-9]+' || true)}

# var validation
if [[ -z "$TICKET" ]]; then
  printf "mising regex pattern 'LP[A-Z]-[0-9]' in the current git branch\n" >&2
  printf "missing argment: TICKET\nusage: cliferay jira TICKET\n" >&2\

  exit 1
fi

echo "opening 🌏 https://liferay.atlassian.net/browse/$TICKET"
open "https://liferay.atlassian.net/browse/$TICKET"