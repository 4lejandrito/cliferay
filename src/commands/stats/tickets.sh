cd $(cliferay folder)
get_current_quarter
git log --since="$since" --until="$until" --pretty=format:'%h %s' $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') | cliferay tickets