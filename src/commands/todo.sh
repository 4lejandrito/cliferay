TITLE="${other_args[*]}"
URLS=($(grep -oE 'https?://[^ ]+' <<<"$TITLE" || true))
CLEAN_TITLE=$(echo "$TITLE" | sed -E 's_https?://[^ ]+__g' | xargs)

RESPONSE=$(curl -s -X POST "https://api.trello.com/1/cards" \
    -d "name=$CLEAN_TITLE" \
    -d "idList=$TRELLO_LIST_ID" \
    -d "key=$TRELLO_API_KEY" \
    -d "token=$TRELLO_TOKEN")

CARD_ID=$(echo "$RESPONSE" | jq -r '.id // empty')

for URL in "${URLS[@]}"; do
    curl -s -X POST "https://api.trello.com/1/cards/$CARD_ID/attachments" \
        -d "url=$URL" \
        -d "key=$TRELLO_API_KEY" \
        -d "token=$TRELLO_TOKEN" >/dev/null
done

if [[ $RESPONSE == *'"id"'* ]]; then
    echo "$RESPONSE" | jq -r '.shortUrl'
else
    echo $RESPONSE
fi
