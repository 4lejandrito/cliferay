cd $(cliferay home)
git log $(get_git_log_period) --pretty=format:'%h %s' $(cliferay team users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') | cliferay tickets