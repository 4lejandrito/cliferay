cd $(cliferay home)
grep '@liferay-headless' .github/CODEOWNERS | awk '{print $1}' | while read folder; do 
  echo $folder;
  git log $(get_git_log_period) --oneline $(cliferay team users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') -- "$folder" | cliferay tickets;
  echo ""
done
