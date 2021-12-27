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


####
#ini_dict = {'a':1, 'b':2, 'c':3, 'd':2}
#rev_dict = {}
  
#for key, value in ini_dict.items():
#    rev_dict.setdefault(value, set()).add(key)
      
#result = [key for key, values in rev_dict.items()
#                              if len(values) > 1]  
#print("duplicate values", str(result))


#JSON Válido   
#validate({"displayName": "Card_Type_Code", "policytag": "projects/269630749177/locations/us-east1/taxonomies/2030734276002480558/policyTags/7623272140653337956"}, schema)
#validate({"displayName": "xxxxxxxxxxx", "policytag": "projects/000000000000/locations/xx-east1/taxonomies/0000000000000000000/policyTags/0000000000000000000"}, schema)

#JSON Inválido - Verifica se policytag é integer
#validate({"displayName": "Card_Type_Code", "policytag": 123}, schema)

#JSON Inválido - Verifica se displayName é integer
#validate({"displayName": 456, "policytag": "projects/000000000000/locations/xx-east1/taxonomies/0000000000000000000/policyTags/0000000000000000000"}, schema)

#JSON Inválido - Não foi passado o campo obrigatório displayName
#validate({"policytag": "projects/000000000000/locations/xx-east1/taxonomies/0000000000000000000/policyTags/0000000000000000000"}, schema)

#JSON Inválido - Não foi passado o campo obrigatório policyTag
#validate({"displayName": "Card_Type_Code"}, schema)

####





