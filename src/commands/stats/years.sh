cd $(cliferay home)
git log --pretty=format:'%cd' --date=format:'%Y' $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g') | sort | uniq -c