# oneliner: grep -v '^#' "$(git rev-parse --show-toplevel)/.github/CODEOWNERS" | awk '{print length, $0}' | sort -nr | cut -d' ' -f2- | while read -r line; do owned_path=$(echo $line | awk '{print $1}'); if [[ "$(realpath --relative-to=$(git rev-parse --show-toplevel) .)" == ${owned_path%/}* ]]; then echo $line | awk '{print $2}'; break; fi; done;
# Sort the CODEOWNERS file by the length of the paths in descending order
# and get the first one that is a prefix of the path received by argument

root_path=$(git rev-parse --show-toplevel)
check_path=$(realpath --relative-to=$root_path $(realpath --relative-to=$(pwd) ${args["path"]}))

grep -v '^#' "$root_path/.github/CODEOWNERS" | awk '{print length, $0}' | sort -nr | cut -d' ' -f2- | while read -r line; do
    owned_path=$(echo $line | awk '{print $1}')
    if [[ "$check_path" == ${owned_path%/}* ]]; then
        echo $line | awk '{print $2}'
        break
    fi
done