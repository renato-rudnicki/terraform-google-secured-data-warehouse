/**
 * Copyright 2022 Google LLC
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
  standalone_organization_roles = [
    "roles/resourcemanager.organizationAdmin",
    "roles/accesscontextmanager.policyAdmin",
    "roles/billing.user",
    "roles/orgpolicy.policyAdmin"
  ]
}

resource "google_organization_iam_member" "standalone-org-roles" {
  for_each = toset(local.standalone_organization_roles)

  org_id = var.org_id
  role   = each.value
  member = "serviceAccount:${var.terraform_service_account}"
}

module "folders" {
  source = "terraform-google-modules/folders/google"

  parent             = "${var.parent_type}/${var.parent_id}"
  names              = var.names
  set_roles          = var.set_roles
  folder_admin_roles = var.folder_admin_roles
}

module "example" {
  source                           = "../../../examples/standalone"
  org_id                           = var.org_id
  folder_id                        = module.folders.parent
  billing_account                  = var.billing_account
  #access_context_manager_policy_id = var.policy_id
  #terraform_service_account       = "ci-account@sdw-data-ing-b50b88-ee23.iam.gserviceaccount.com"
  access_context_manager_policy_id = var.access_context_manager_policy_id
  terraform_service_account        = var.terraform_service_account
  perimeter_additional_members     = var.perimeter_additional_members
  #perimeter_additional_members     = []
  delete_contents_on_destroy       = true
  #security_administrator_group     = var.security_administrator_group
  #network_administrator_group      = var.network_administrator_group
  #security_analyst_group           = var.security_analyst_group
  #data_analyst_group               = var.data_analyst_group
  #data_engineer_group              = var.data_engineer_group
  data_engineer_group              = var.group_email[2]
  data_analyst_group               = var.group_email[2]
  security_analyst_group           = var.group_email[2]
  network_administrator_group      = var.group_email[2]
  security_administrator_group     = var.group_email[2]

  depends_on = [
    module.folders,
    google_organization_iam_member.standalone-org-roles
  ]
}
