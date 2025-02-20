cd $(cliferay folder)
emails=${args[emails]:-}
get_current_period
git log --since="$since" --until="$until" --pretty="%ae %an" $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') | iconv -f utf-8 -t ascii//TRANSLIT | awk '{name=$2" "$3; gsub(/[[:punct:]]/, "", name); print name}' | sort | uniq -c | sort -nr