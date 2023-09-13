JSON=$(
  liferay-curl -X "PUT" "http://localhost:8080/o/object-admin/v1.0/object-definitions/by-external-reference-code/University" \
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
            "externalReferenceCode": "university-name",
            "listTypeDefinitionId": 0,
            "label": {
              "en_US": "University name"
            },
            "type": "String",
            "required": true,
            "system": false,
            "name": "universityName",
            "indexedAsKeyword": false
          }
        ],
        "pluralLabel": {
          "en-US": "Universities"
        },
        "portlet": true,
        "scope": "company",
        "label": {
          "en-US": "University"
        },
        "externalReferenceCode": "University",
        "name": "University"
      }'
)

echo $JSON | jq

if [[ $(echo $JSON | jq '.status.code') != 0 ]]; then
  liferay-curl -X "POST" "http://localhost:8080/o/object-admin/v1.0/object-definitions/$(echo $JSON | jq '.id')/publish"
fi

liferay-curl -X "PUT" "http://localhost:8080/o/c/universities/by-external-reference-code/Oxford" \
     -H 'Content-Type: application/json' \
     -d $'{
    "universityName": "Oxford"
  }'

liferay-curl -X "PUT" "http://localhost:8080/o/c/universities/by-external-reference-code/Cambridge" \
     -H 'Content-Type: application/json' \
     -d $'{
    "universityName": "Cambridge"
  }'