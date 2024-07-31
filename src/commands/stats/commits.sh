cd $(cliferay folder)
emails=${args[emails]:-}
get_current_quarter
git log --since="$since" --until="$until" --oneline $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g')