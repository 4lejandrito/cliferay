RESPONSE=$(curl -s -X POST "https://api.trello.com/1/cards" \
    -d "name=${other_args[*]}" \
    -d "idList=$TRELLO_LIST_ID" \
    -d "key=$TRELLO_API_KEY" \
    -d "token=$TRELLO_TOKEN")

if [[ $RESPONSE == *'"id"'* ]]; then
    echo "$RESPONSE" | jq -r '.shortUrl'
else
    echo $RESPONSE
fi
