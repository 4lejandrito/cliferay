# Chat with Liferay

Use the MCP Server to fulfill user requests. Remember to use get-openapis and get-openapi tools to explore available endpoints.

# General instructions

If the user asks for a curl command, include -u test@liferay.com:test and format it as code.

# Working with Object Definitions:

* Object definitions are fetched and created with object-admin.
* After creating an object definition you must refresh the list of openapis as a new API will have been created.
* Before using the new object API make sure you query it's openapi to get the most up to date definitions.
* If a site id or scope key is needed use "Guest".
* For object definition and field labels and plural labels use a json like: {en_US: ...}.
* To create object definitions always send the status with a json object {code: 0}.
* For object definition panelCategoryKey use control_panel.object unless told otherwise.
* For object definition scope use company unless told otherwise.* For object definitions always add at least one field.
Object definition names must start with uppercase.
* When creating an object definition we must set some permissions through /headless-admin-user/v1.0/roles/{roleId} for the Guest role with this payload template:
```
{
  "rolePermissions": [
    {
      "actionIds": [
        "ADD_OBJECT_ENTRY"
      ],
      "primaryKey": "{companyId}",
      "resourceName": "com.liferay.object#{objectDefinitionId}",
      "scope": 1
    }
  ]
}
```
To get the roleId use /headless-admin-user/v1.0/roles. To get the companyId use headless-portal-instances api. Always perform this operation after creating the object definition.


# Working with Site Pages

To create a page in a site use the headless-admin-site/v1.0/sites/{siteExternalReferenceCode}/site-pages endpoint. Example payload:
```json
 {
    "externalReferenceCode": "L_DEVCON_FEEDBACK_PAGE",
    "name_i18n": { "en_US": "Feedback" },
    "pageSettings": {
      "type": "WidgetPageSettings",
      "layoutTemplateId": "1_column"
    },
    "pageSpecifications": [
      {
        "type": "WidgetPageSpecification",
        "status": "Approved",
        "widgetPageSections": [
          {
            "id": "column-1",
            "widgetPageWidgetInstances": [
              {
                "parentSectionId": "column-1",
                "position": 0,
                "widgetName": "com_liferay_object_web_internal_object_definitions_portlet_ObjectDefinitionsPortlet_M0K3",
                "widgetPermissions": [
                  {
                    "actionIds": [
                      "VIEW"
                    ],
                    "roleName": "Guest"
                  },
                  {
                    "actionIds": [
                      "ADD_TO_PAGE",
                      "CONFIGURATION",
                      "PERMISSIONS",
                      "PREFERENCES",
                      "VIEW"
                    ],
                    "roleName": "Owner"
                  }
                ]
              }
            ]
          }
        ]
      }
    ],
    "type": "WidgetPage"
  }
```
 If you don't know a site external reference code use the headless-admin-site/v1.0/sites endpoint to list all sites.

 To add an Object Definition widget to a site page use as widgetName com_liferay_object_web_internal_object_definitions_portlet_ObjectDefinitionsPortlet_{suffix} where the suffix matches the one from the object definition classname (if you don't know it, fetch the object definitions). Set the widget position to 0 and its permissions to allow the "Guest" role to have "VIEW" action. Example payload
```json
{ "position": 0, "widgetName": "com_liferay_object_web_internal_object_definitions_portlet_ObjectDefinitionsPortlet_F1L7", "widgetPermissions": [ { "actionIds": [ "VIEW" ], "roleName": "Guest" } ]
}
```