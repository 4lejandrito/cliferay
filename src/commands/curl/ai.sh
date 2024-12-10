OPENAPI_FILE=$(mktemp)
OPENAI_REQUEST_FILE=$(mktemp)

jq -n --arg input "${args[prompt]}" --arg openapis "$(liferay-curl -s "http://localhost:8080/o/openapi")" \
  '{
    "model": "gpt-4o",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant that will select the most relevant OpenAPI URL based on the prompt. Here are the available OpenAPIs:\n\n\($openapis)"},
      {"role": "user", "content": "\($input)"}
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "strict": true,
          "name": "select_openapi",
          "description": "Return the OpenAPI URL.",
          "parameters": {
            "type": "object",
            "properties": {
              "url": {
                "type": "string",
                "description": "The OpenAPI URL."
              }
            },
            "additionalProperties": false,
            "required": ["url"]
          }
        }
      }
    ],
    "tool_choice": {"type": "function", "function": {"name": "select_openapi"}}
}' >$OPENAI_REQUEST_FILE

OPENAPI_URL=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @$OPENAI_REQUEST_FILE | jq -r '.choices[0].message.tool_calls[0].function.arguments' | jq -r '.url')

curl -s "$OPENAPI_URL" -u test@liferay.com:test >$OPENAPI_FILE

jq -n --arg input "${args[prompt]}" --rawfile openapi $OPENAPI_FILE \
  '{
    "model": "gpt-4o",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant that transforms user instructions into curl commands based on the given OpenAPI specification."},
      {"role": "system", "content": "Here is the OpenAPI specification:\n\n\($openapi)"},
      {"role": "system", "content": "If a site id or scope key is needed use 20117"},
      {"role": "system", "content": "For object definition and field labels and plural labels use a json like: en_US: ..."},
      {"role": "system", "content": "To create object definitions always send the status with a json object code: 0"},
      {"role": "system", "content": "For object definition panelCategoryKey use control_panel.object unless told otherwise"},
      {"role": "system", "content": "For object definition scope use company unless told otherwise"},
      {"role": "system", "content": "For object definitions always add at least one field"},
      {"role": "system", "content": "Object definition names must start with uppercase"},
      {"role": "system", "content": "Use this credentials -u test@liferay.com:test"},
      {"role": "user", "content": "\($input)"}
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "strict": true,
          "name": "generate_curl_command",
          "description": "Generate a curl command based on user input and OpenAPI specification.",
          "parameters": {
            "type": "object",
            "properties": {
              "curl_command": {
                "type": "string",
                "description": "The generated curl command."
              }
            },
            "additionalProperties": false,
            "required": ["curl_command"]
          }
        }
      }
    ],
    "tool_choice": {"type": "function", "function": {"name": "generate_curl_command"}}
}' >$OPENAI_REQUEST_FILE

CURL_COMMAND=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @$OPENAI_REQUEST_FILE | jq -r '.choices[0].message.tool_calls[0].function.arguments' | jq -r '.curl_command')

if [[ ${args[--generate]} -eq 1 ]]; then
  echo "$CURL_COMMAND"
else
  eval "$CURL_COMMAND"
fi