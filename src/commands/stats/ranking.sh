cd $(cliferay folder)
emails=${args[emails]:-}
git log --since="2024-04-01" --until="2024-07-01" --pretty="%ae %an" $(echo ${emails//\"/} | sed 's/[^ ]* */--author=& /g') | iconv -f utf-8 -t ascii//TRANSLIT | awk '{name=$2" "$3; gsub(/[[:punct:]]/, "", name); print name}' | sort | uniq -c | sort -nr