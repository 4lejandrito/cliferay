emails=${args[emails]:-}
git log --pretty=format:'%h %s' $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') --since="2024-01-01" --until="2024-04-01" | cliferay tickets