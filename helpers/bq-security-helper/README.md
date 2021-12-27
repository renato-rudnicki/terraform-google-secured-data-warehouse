# Policy Tags Helper

This helper will work on Bigquery and Taxonomy to list its schemas and generate a new one. We can find 3 functionalities here: 
   * Export Bigquery schema
   * Export Taxonomy list
   * Generate a new schema crossing Bigquery columns with Taxonomy policy tags.

__Note:__ This helper is mainly for sample purpose. You should use your security team's recommend approach to generate and handle key material properly.

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

### Exporting Bigquery schema

```sh
python3 bq_security_helper.py --export bigquery \
--project_id ${project_id} \
--dataset_id ${dataset_id} \
--table_id ${table_id} \
--output_file <filename where the schema will be saved>
```

The output_file parameter is optional. If declared, then you need to provide the filename where the Bigquery schema will be saved. If not declared, the output will be showed on screen. 


### Exporting Taxonomy list

```sh
python3 bq_security_helper.py --export datacatalog \
--project_number ${project_number} \
--location ${location} \
--taxonomy_id ${taxonomy_id} \
```

The output_file parameter is optional. If declared, then you need to provide the filename where the taxonomy list will be saved. If not declared, the output will be showed on screen. 


### Generating schema with Bigquery columns and Taxonomy policy tags.

```sh
python3 bq_security_helper.py --generate secured_schema \
--schema_mapping map.json \
--bq_input_file schema_bigquery.json \
--bq_generate_schema my_policytags.json
```

```sh
--schema_mapping=<Json file created by user mapping Bigquery column crosssing with Policy tags from Taxonomy>
--bq_input_file=<Bigquery schema filename>
```

The bq_generate_schema parameter is optional. If declared, then you need to provide the filename where the schema output will be saved. If not declared, the output will be showed on screen. 

### Example for --schema_mapping json file

This file needs to be created by user crossing data from the Bigquery columns and Taxonomy policy tags. This must be a valid json file following the example below: 

```sh
{
  "Bigquery_column_1": [
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