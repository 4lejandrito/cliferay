emails=${args[emails]:-}
git log --since="2024-01-01" --until="2024-04-01" --pretty=format:'%h %s' $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') | cliferay tickets