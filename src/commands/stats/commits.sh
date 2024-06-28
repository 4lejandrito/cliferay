cd $(cliferay folder)
emails=${args[emails]:-}
git log --since="2024-04-01" --until="2024-07-01" --oneline $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g')