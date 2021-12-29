/**
 * Copyright 2021 Google LLC
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

locals {
  location                    = "us-east4"
  non_confidential_dataset_id = "non_confidential_dataset"
  confidential_dataset_id     = "secured_dataset"
  dlp_transformation_type     = "RE-IDENTIFY"
  taxonomy_name               = "secured_taxonomy"
  taxonomy_display_name       = "${local.taxonomy_name}-${random_id.suffix.hex}"
  confidential_table_id       = "${trimsuffix(local.cc_file_name, ".csv")}_re_id"
  cc_file_name                = "cc_10000_records.csv"
  cc_file_path                = "${path.module}/assets"
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "secured_data_warehouse" {
  source = "../.."

  org_id                           = var.org_id
  data_governance_project_id       = module.base_projects.data_governance_project_id
  confidential_data_project_id     = module.base_projects.confidential_data_project_id
  non_confidential_data_project_id = module.base_projects.non_confidential_data_project_id
  data_ingestion_project_id        = module.base_projects.data_ingestion_project_id
  sdx_project_number               = module.template_project.sdx_project_number
  terraform_service_account        = var.terraform_service_account
  access_context_manager_policy_id = var.access_context_manager_policy_id
  bucket_name                      = "data-ingestion"
  pubsub_resource_location         = local.location
  location                         = local.location
  trusted_locations                = ["us-locations"]
  dataset_id                       = local.non_confidential_dataset_id
  confidential_dataset_id          = local.confidential_dataset_id
  cmek_keyring_name                = "cmek_keyring"
  delete_contents_on_destroy       = var.delete_contents_on_destroy
  perimeter_additional_members     = var.perimeter_additional_members
  data_engineer_group              = var.data_engineer_group
  data_analyst_group               = var.data_analyst_group
  security_analyst_group           = var.security_analyst_group
  network_administrator_group      = var.network_administrator_group
  security_administrator_group     = var.security_administrator_group

  depends_on = [
    module.base_projects,
    module.iam_projects,
    module.centralized_logging,
    google_project_iam_binding.remove_owner_role,
    google_project_iam_binding.remove_owner_role_from_template
  ]
}

resource "google_storage_bucket_object" "sample_file" {
  name         = local.cc_file_name
  source       = "${local.cc_file_path}/${local.cc_file_name}"
  content_type = "text/csv"
  bucket       = module.secured_data_warehouse.data_ingestion_bucket_name

  depends_on = [
    module.secured_data_warehouse
  ]
}

module "de_identification_template" {
  source = "../..//modules/de-identification-template"

  project_id                = module.base_projects.data_governance_project_id
  terraform_service_account = var.terraform_service_account
  crypto_key                = module.tek_wrapping_key.keys[local.kek_key_name]
  wrapped_key               = local.wrapped_key_secret_data
  dlp_location              = local.location
  template_id_prefix        = "de_identification"
  template_file             = "${path.module}/templates/deidentification.tmpl"
  dataflow_service_account  = module.secured_data_warehouse.dataflow_controller_service_account_email
}

module "re_identification_template" {
  source = "../..//modules/de-identification-template"

  project_id                = module.base_projects.data_governance_project_id
  terraform_service_account = var.terraform_service_account
  crypto_key                = module.tek_wrapping_key.keys[local.kek_key_name]
  wrapped_key               = local.wrapped_key_secret_data
  dlp_location              = local.location
  template_id_prefix        = "re_identification"
  template_file             = "${path.module}/templates/reidentification.tmpl"
  dataflow_service_account  = module.secured_data_warehouse.confidential_dataflow_controller_service_account_email
}

resource "google_artifact_registry_repository_iam_member" "docker_reader" {
  provider = google-beta

  project    = module.template_project.project_id
  location   = local.location
  repository = "flex-templates"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${module.secured_data_warehouse.dataflow_controller_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "confidential_docker_reader" {
  provider = google-beta

  project    = module.template_project.project_id
  location   = local.location
  repository = "flex-templates"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${module.secured_data_warehouse.confidential_dataflow_controller_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "python_reader" {
  provider = google-beta

  project    = module.template_project.project_id
  location   = local.location
  repository = "python-modules"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${module.secured_data_warehouse.dataflow_controller_service_account_email}"
}

resource "google_artifact_registry_repository_iam_member" "confidential_python_reader" {
  provider = google-beta

  project    = module.template_project.project_id
  location   = local.location
  repository = "python-modules"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${module.secured_data_warehouse.confidential_dataflow_controller_service_account_email}"
}
