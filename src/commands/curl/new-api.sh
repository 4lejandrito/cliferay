curl --no-progress-meter -X "POST" "http://localhost:8080/o/object-admin/v1.0/object-definitions" \
     -H 'Content-Type: application/json' \
     -u 'test@liferay.com:test' \
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
}' | jq

curl --no-progress-meter -X "POST" "http://localhost:8080/o/c/universities/batch" \
     -H 'Content-Type: application/json' \
     -u 'test@liferay.com:test' \
     -d $'[
  {
    "universityName": "Oxford"
  },
  {
    "universityName": "Cambridge"
  }
]' | jq

curl --no-progress-meter -X "POST" "http://localhost:8080/o/headless-builder/applications/" \
     -H 'Content-Type: application/json' \
     -u 'test@liferay.com:test' \
     -d $'{
  "baseURL": "my-application",
  "title": "My application",
  "externalReferenceCode": "my-application",
  "apiApplicationToAPIEndpoints": [
    {
      "path": "/my-endpoint",
      "scope": "company",
      "externalReferenceCode": "my-endpoint",
      "name": "name",
      "description": "description",
      "httpMethod": "get"
    }
  ],
  "applicationStatus": "unpublished",
  "apiApplicationToAPISchemas": [
    {
      "externalReferenceCode": "my-schema",
      "mainObjectDefinitionERC": "University",
      "description": "description",
      "name": "MySchema",
      "apiSchemaToAPIProperties": [
        {
          "objectFieldERC": "university-name",
          "name": "name",
          "description": "description"
        }
      ]
    }
  ]
}' | jq

curl --no-progress-meter -X "PUT" "http://localhost:8080/o/headless-builder/schemas/by-external-reference-code/my-schema/responseAPISchemaToAPIEndpoints/my-endpoint" \
     -H 'Content-Type: application/json' \
     -u 'test@liferay.com:test' | jq

curl --no-progress-meter -X "PATCH" "http://localhost:8080/o/headless-builder/applications/by-external-reference-code/my-application" \
     -H 'Content-Type: application/json' \
     -u 'test@liferay.com:test' \
     -d $'{
  "applicationStatus": "published"
}' | jq

curl --no-progress-meter "http://localhost:8080/o/c/my-application/my-endpoint" \
     -u 'test@liferay.com:test' | jq