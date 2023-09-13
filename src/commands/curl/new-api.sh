cliferay curl new-object
liferay-curl -X "DELETE" "http://localhost:8080/o/headless-builder/applications/by-external-reference-code/my-application"
liferay-curl -X "POST" "http://localhost:8080/o/headless-builder/applications" \
     -H 'Content-Type: application/json' \
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
  "applicationStatus": "published",
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
}'
liferay-curl -X "PUT" "http://localhost:8080/o/headless-builder/schemas/by-external-reference-code/my-schema/responseAPISchemaToAPIEndpoints/my-endpoint"
liferay-curl "http://localhost:8080/o/c/my-application/my-endpoint"