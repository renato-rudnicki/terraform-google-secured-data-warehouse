# Policy Tags Helper

This helper will export an existing [Bigquery schema](https://cloud.google.com/bigquery/docs/schemas) and a list of Data Catalog taxonomy tags that will be used together to generate a new Bigquery schema with [column level security](https://cloud.google.com/bigquery/docs/column-level-security).

__Note:__ This helper is mainly for testing purpose. You should contact your security team's to know how to handle column level security configuration.

## Bigquery security helper usage

### Install PIP

```sh
python3 -m pip install --user --upgrade pip

python3 -m pip --version
```

### Install Virtual Env

```sh
python3 -m pip install --user virtualenv
```

### Creating a virtual environment

```sh
cd helpers/bq_security

python3 -m venv bq_security_helper
```

### Activating a virtual environment

```sh
source bq_security_helper/bin/activate
```

### Install dependencies

```sh
pip install --upgrade pip

pip install -r requirements.txt
```

### Set default application credentials

```sh
gcloud auth application-default login
```


### Run Script

```sh
export project_id=<bigquery-project-id>
export dataset_id=<bigquery-dataset-id>
export table_id=<bigquery-table-id>
export project_number=<datacatalog-project-number>
export location=<datacatalog-location>
export taxonomy_id=<datacatalog-taxonomy-id>
```

### Exporting existing Bigquery schema

```sh
python3 bq_security_helper.py --export bigquery \
--project_id ${project_id} \
--dataset_id ${dataset_id} \
--table_id ${table_id} \
--output_file <filename where the schema will be saved>
```

The output_file parameter is optional. If not declared, the output will be send to the standard output. 


### Exporting Taxonomy list

```sh
python3 bq_security_helper.py --export datacatalog \
--project_number ${project_number} \
--location ${location} \
--taxonomy_id ${taxonomy_id} \
```

The output_file parameter is optional. If not declared, the output will be send to the standard output. 


### Generating a new schema with Bigquery column security using the Taxonomy policy tags

```sh
python3 bq_security_helper.py --generate secured_schema \
--bq_input_file bigquery_schema.json \
--bq_generate_schema exported_policytags.json \
--schema_mapping column_security_level_map.json
```

* bigquery_schema.json is the result...
* exported_policytags.json is the result...

The column_security_level_map.json will be explained in details in the next section.

The OUTPUT_FILE parameter is optional. If not declared, the output will be send to the standard output. 



### Example for column_security_level_map json file

This file needs to be created by user crossing data from the Bigquery columns and Taxonomy policy tags. This must be a valid json file following the example below: 

```sh
{
  "social_security_number": [
    "projects/1234567890/locations/us-east1/taxonomies/12345678901234567890/policyTags/1111111111"
  ],
  "Bigquery_column_2": [
    "projects/1234567890/locations/us-east1/taxonomies/12345678901234567890/policyTags/2222222222"
  ],
  "Bigquery_column_3": [
    "projects/1234567890/locations/us-east1/taxonomies/12345678901234567890/policyTags/3333333333"
  ]
}
```

Considering this schema 
(exemplo do schema)

and this taxonomy, 
(exemplo da taxonomia)

 this will be a valid map.
 (exemplo do map)