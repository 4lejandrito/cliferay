JSON=$(
  liferay-curl -X "PUT" "http://localhost:8080/o/object-admin/v1.0/object-definitions/by-external-reference-code/Versioned" \
     -H 'Content-Type: application/json' \
     -d $'{
        "active": true,
        "enableObjectEntryVersioning": true,
        "status": {
          "code": 0
        },
        "objectFields": [
          {
            "DBType": "String",
            "indexed": true,
            "indexedLanguageId": "",
            "externalReferenceCode": "versioned-name",
            "listTypeDefinitionId": 0,
            "label": {
              "en_US": "Versioned name"
            },
            "type": "String",
            "required": true,
            "system": false,
            "name": "versionedName",
            "indexedAsKeyword": false
          }
        ],
        "panelCategoryKey": "control_panel.object",
        "pluralLabel": {
          "en-US": "Versioneds"
        },
        "portlet": true,
        "scope": "company",
        "label": {
          "en-US": "Versioned"
        },
        "externalReferenceCode": "Versioned",
        "name": "Versioned"
      }'
)

echo $JSON | jq

if [[ $(echo $JSON | jq '.status.code') != 0 ]]; then
  liferay-curl -X "POST" "http://localhost:8080/o/object-admin/v1.0/object-definitions/$(echo $JSON | jq '.id')/publish"
fi

liferay-curl -X "PUT" "http://localhost:8080/o/c/versioneds/by-external-reference-code/A" \
     -H 'Content-Type: application/json' \
     -d $'{
    "versionedName": "A"
  }'

liferay-curl -X "PUT" "http://localhost:8080/o/c/versioneds/by-external-reference-code/B" \
     -H 'Content-Type: application/json' \
     -d $'{
    "versionedName": "B"
  }'