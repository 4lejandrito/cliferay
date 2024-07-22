liferay-curl -X "DELETE" "http://localhost:8080/o/headless-builder/applications/by-external-reference-code/headless-builder-test"
liferay-curl -X "POST" "http://localhost:8080/o/headless-builder/applications" \
     -H 'Content-Type: application/json' \
     -d $'{
  "baseURL": "headless-builder-test",
  "title": "API Builder Test",
  "externalReferenceCode": "headless-builder-test",
  "apiApplicationToAPIEndpoints": [
    {
      "path": "/test1",
      "scope": "company",
      "externalReferenceCode": "test-endpoint-1",
      "name": "Test 1",
      "description": "description",
      "httpMethod": "get"
    },
    {
      "path": "/test2",
      "scope": "company",
      "externalReferenceCode": "test-endpoint-2",
      "name": "Test 2",
      "description": "description",
      "httpMethod": "get"
    }
  ],
  "applicationStatus": "published",
  "apiApplicationToAPISchemas": [
    {
      "externalReferenceCode": "test-schema",
      "mainObjectDefinitionERC": "L_API_ENDPOINT",
      "description": "description",
      "name": "Test Schema",
      "apiSchemaToAPIProperties": [
        {
          "objectFieldERC": "PATH",
          "name": "path",
          "description": "description"
        }
      ]
    }
  ]
}'
liferay-curl -X "PUT" "http://localhost:8080/o/headless-builder/schemas/by-external-reference-code/test-schema/responseAPISchemaToAPIEndpoints/test-endpoint-1"
liferay-curl -X "PUT" "http://localhost:8080/o/headless-builder/schemas/by-external-reference-code/test-schema/responseAPISchemaToAPIEndpoints/test-endpoint-2"
liferay-curl "http://localhost:8080/o/c/headless-builder-test/test1"