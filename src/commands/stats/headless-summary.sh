cd $(cliferay folder)
get_current_period
grep '@liferay-headless' .github/CODEOWNERS | awk '{print $1}' | while read folder; do 
  echo $folder;
  git log --since="$since" --until="$until" --oneline $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') -- "$folder" | cliferay tickets;
  echo ""
done
