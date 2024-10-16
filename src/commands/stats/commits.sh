cd $(cliferay folder)
get_current_quarter
git log --since="$since" --until="$until" --oneline $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g')