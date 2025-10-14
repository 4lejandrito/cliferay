cd $(cliferay home)
emails=${args[emails]:-}
git log $(get_git_log_period) --pretty="%ae %an" $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') | iconv -f utf-8 -t ascii//TRANSLIT | awk '{name=$2" "$3; gsub(/[[:punct:]]/, "", name); print name}' | sort | uniq -c | sort -nr