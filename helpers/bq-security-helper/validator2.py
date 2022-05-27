import os
import json
import io
import jsonschema
from jsonschema import validate
from pathlib import Path


#Verify if json file exists
path_to_file = 'user_file.json'
path = Path(path_to_file)

if path.is_file():
    print()
else:
    print(f'The file {path_to_file} does not exist')


#Validate json schema
schema = {
          "type" : "object",
          "required": [ "displayName", "policytag" ],
          "properties": {
              "ColumnName": {
                  "type": "string"
              },
              "policytag": {
                  "type": "string"
              }
            }
          }

with open('user_file.json') as f:
    data_schema = json.load(f)
    for data in data_schema:
        validate(instance=data, schema=schema)


dc_policytag = "projects/269630749177/locations/us-east1/taxonomies/2030734276002480558/policyTags/7623272140653337956"
policytag = "projects/269630749177/locations/us-east1/taxonomies/2030734276002480558/policyTags/762327214065333795"
if dc_policytag == str(policytag):
    print('right')
else:
    print('Wrong dc_policytag')

bq_column = "CVVCVV2"
displayName = "CVVCVV3"
if bq_column == str(displayName):
    print('You got bq_column right')
else:
    print('wrong bq_column')


