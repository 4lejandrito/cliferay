cd $(cliferay folder)
git log $(get_git_log_period) --pretty=format:'%h %s' $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') | cliferay tickets