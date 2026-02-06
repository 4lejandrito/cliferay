cd $(cliferay home)
git log $(get_git_log_period) --oneline $(cliferay team users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g')