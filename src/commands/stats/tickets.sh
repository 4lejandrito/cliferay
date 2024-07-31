cd $(cliferay folder)
emails=${args[emails]:-}
get_current_quarter
git log --since="$since" --until="$until" --pretty=format:'%h %s' $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') | cliferay tickets