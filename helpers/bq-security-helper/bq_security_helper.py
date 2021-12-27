# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import sys
import json
import io
import argparse
from google.cloud import datacatalog_v1
from google.cloud import bigquery

def export_bigquery(args):
  project = args.project_id
  dataset = args.dataset_id
  bq_table = args.table_id
  bigquery_client = bigquery.Client()
  table = bigquery_client.get_table("{}.{}.{}".format(project, dataset, bq_table))
  output = io.StringIO()

  if args.output_file is not None:
    with open(args.output_file, 'w') as f:
      bigquery_client.schema_to_json(table.schema, output)
      print(output.getvalue(), file=f)
  else:
    fake_file = io.StringIO()
    bigquery_client.schema_to_json(table.schema, fake_file)
    print(fake_file.getvalue())


def export_taxonomy(args):
  policy_tag_manager_client = datacatalog_v1.PolicyTagManagerClient()
  policy_tag = policy_tag_manager_client.list_policy_tags(
    parent=f"projects/{args.project_number}/locations/{args.location}/taxonomies/{args.taxonomy_id}",
  )

  output = []    
  for x in list(policy_tag):
    output.append({
        "description": x.description,
        "name": x.name,
        "displayName": x.display_name
    })

  policy_output = args.output_file
  if policy_output is not None:
    with open(policy_output, 'w') as f:
      json.dump(output, f, indent=4)
  else:
    print(json.dumps(output, indent=4))
  

def generate_bq_schema(args):
  if args.command == 'secured_schema':
    with open(args.bq_input_file) as bigquery_schema:
      policytag_json_schema = json.load(bigquery_schema)

    user_schema_mapping = args.schema_mapping
    schema_output_file = args.bq_generate_schema
    with open(user_schema_mapping) as maps:
      map_policy_to_field = json.load(maps)
      for schema in policytag_json_schema:
          if schema['name'] in map_policy_to_field.keys():
              if "policyTags" in schema:
                  schema['policyTags']['names'] = map_policy_to_field[schema['name']] + schema['policyTags']['names']
              else:
                  schema['policyTags'] = {"names": map_policy_to_field[schema['name']]}

    if schema_output_file is not None:
      with open(schema_output_file, 'w') as f:
        json.dump(policytag_json_schema, f, indent=4)
    else:
      print(json.dumps(policytag_json_schema, indent=4))


if __name__ == '__main__':
    parent_parser = argparse.ArgumentParser(description='The parent parser', add_help=True)
    parent_parser.add_argument("--export", action='store_true', dest='export')
    parent_parser.add_argument("--generate", action='store_true', dest='generate')

    subparsers = parent_parser.add_subparsers(dest="command")

    subparser_bigquery= subparsers.add_parser('bigquery', help='Export existing Bigquery schema')
    subparser_bigquery.add_argument('--project_id',  type=str, required=True, help='Bigquery Project ID')
    subparser_bigquery.add_argument('--dataset_id', type=str, required=True, help='Bigquery Dataset ID')
    subparser_bigquery.add_argument('--table_id', type=str, required=True, help='Bigquery Table ID')
    subparser_bigquery.add_argument('--output_file', type=str, required=False, help='Output file to save Bigquery Schema')

    subparser_datacatalog = subparsers.add_parser('datacatalog', help='Export existing PolicyTags list')
    subparser_datacatalog.add_argument('--project_number', type=str, required=True, help="Datacatalog Project number")
    subparser_datacatalog.add_argument('--location', type=str, required=True, help="Datacatalog location")
    subparser_datacatalog.add_argument('--taxonomy_id', type=str, required=True, help="Datacatalog Taxonomy ID")
    subparser_datacatalog.add_argument('--output_file', type=str, required=False, help="Output file to save Taxonomy list")

    subparser_policytag = subparsers.add_parser('secured_schema', help='Generate Bigquery schema with its respective PolicyTags')
    subparser_policytag.add_argument('--bq_input_file', type=str, required=True, help="Bigquery schema file")
    subparser_policytag.add_argument('--bq_generate_schema', type=str, required=False, help="Output file where Bigquery schema will be saved with Taxonomy")
    subparser_policytag.add_argument('--schema_mapping', type=str, required=True, help="Input file with Policy Tags and Bigquery column")

    args = parent_parser.parse_args()
    if args.export:
      if args.command == 'bigquery':
        export_bigquery(args)
      if args.command == 'datacatalog':
        export_taxonomy(args)
    if args.generate:
      generate_bq_schema(args)
