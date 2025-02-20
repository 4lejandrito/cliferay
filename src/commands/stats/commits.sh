cd $(cliferay folder)
get_current_period
git log --since="$since" --until="$until" --oneline $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g')