emails=${args[emails]:-}
git log --pretty=format:'%cd' --date=format:'%Y' $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') | sort | uniq -c