cd $(cliferay folder)
grep '@liferay-headless' .github/CODEOWNERS | awk '{print $1}' | while read folder; do 
  echo $folder;
  git log $(get_git_log_period) --oneline $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') -- "$folder" | cliferay tickets;
  echo ""
done
