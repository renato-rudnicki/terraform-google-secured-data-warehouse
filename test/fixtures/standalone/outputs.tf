/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// depends_on is necessary to ensure that the bigquery table is already created
output "bigquery_confidential_table" {
  description = "The bigquery table created for the confidential project."
  value       = module.example.bigquery_confidential_table
}

// depends_on is necessary to ensure that the bigquery table is already created
output "bigquery_non_confidential_table" {
  description = "The bigquery table created for the non confidential project."
  value       = module.example.bigquery_non_confidential_table
}

#####adicionado para fixar o erro do teste verify-standalone
output "project_id" {
  description = "The project_id used to create infra."
  value       = var.data_ingestion_project_id[0]
}

output "data_governance_project_id" {
  description = "The data_governance_project_id used to create infra."
  value       = var.data_governance_project_id[0]
}

output "non_confidential_data_project_id" {
  description = "The non_confidential_data_project_id used to create bigquery."
  value       = var.non_confidential_data_project_id[0]
}
#####

#### create folder
output "ids" {
  description = "Folder ids."
  value       = module.folders.ids
}

output "names" {
  description = "Folder names."
  value       = module.folders.names
}

#output "id" {
#  description = "Folder id (for single use)."
#  value       = module.folders.name
#}

output "parent_id" {
  description = "Id of the resource under which the folder will be placed."
  value       = var.parent_id
}

# output "ids_list" {
#   description = "List of folder ids."
#   value       = module.folders.ids_list
# }


# output "names_list" {
#   description = "List of folder names."
#   value       = module.folders.names_list
# }
##
