JSON=$(
  liferay-curl -X "PUT" "http://localhost:8080/o/object-admin/v1.0/object-definitions/by-external-reference-code/School" \
     -H 'Content-Type: application/json' \
     -d $'{
        "active": true,
        "status": {
          "code": 0
        },
        "objectFields": [
          {
            "DBType": "String",
            "indexed": true,
            "indexedLanguageId": "",
            "externalReferenceCode": "school-name",
            "listTypeDefinitionId": 0,
            "label": {
              "en_US": "School name"
            },
            "type": "String",
            "required": true,
            "system": false,
            "name": "schoolName",
            "indexedAsKeyword": false
          }
        ],
        "panelCategoryKey": "site_administration.content",
        "pluralLabel": {
          "en-US": "Schools"
        },
        "portlet": true,
        "scope": "site",
        "label": {
          "en-US": "School"
        },
        "externalReferenceCode": "School",
        "name": "School"
      }'
)

echo $JSON | jq

if [[ $(echo $JSON | jq '.status.code') != 0 ]]; then
  liferay-curl -X "POST" "http://localhost:8080/o/object-admin/v1.0/object-definitions/$(echo $JSON | jq '.id')/publish"
fi

liferay-curl -X "PUT" "http://localhost:8080/o/c/schools/scopes/Guest/by-external-reference-code/leon" \
     -H 'Content-Type: application/json' \
     -d $'{
    "schoolName": "León Felipe"
  }'

liferay-curl -X "PUT" "http://localhost:8080/o/c/schools/scopes/Guest/by-external-reference-code/padre" \
     -H 'Content-Type: application/json' \
     -d $'{
    "schoolName": "Padre Jerónimo"
  }'