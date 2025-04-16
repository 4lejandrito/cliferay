cd $(cliferay folder)

COMMITS=($(git log $(get_git_log_period) --pretty=format:"%H" $(cliferay stats users emails ${args[user]:-} | sed 's/[^ ]* */--author=& /g')))

declare -A folder_commit_map

for COMMIT in "${COMMITS[@]}"; do
  FILES=$(git diff-tree --no-commit-id --name-only -r "$COMMIT")

  while IFS= read -r FILE; do
    DIR=$(dirname "$FILE")

    while [[ "$DIR" != "." && "$DIR" != "/" ]]; do
      if [ -f "$DIR/build.gradle" ]; then
        folder_commit_map["$DIR"]+="$COMMIT "
        break
      fi
      DIR=$(dirname "$DIR")
    done
  done <<< "$FILES"
done

RESULTS=()
for FOLDER in "${!folder_commit_map[@]}"; do
  UNIQUE_COUNT=$(echo "${folder_commit_map[$FOLDER]}" | tr ' ' '\n' | sort -u | wc -l)
  RESULTS+=("$UNIQUE_COUNT $FOLDER")
done

printf "%s\n" "${RESULTS[@]}" | sort -nr | awk '{ count=$1; $1=""; sub(/^ /, "", $0); printf "%s %d\n", $0, count }'
