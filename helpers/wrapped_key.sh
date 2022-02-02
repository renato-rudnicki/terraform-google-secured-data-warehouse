#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Important information for understanding the script:
# https://cloud.google.com/kms/docs/encrypt-decrypt
# https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets

set -e

terraform_service_account=$1
key=$2
secret_name=$3
project_id=$4
exe_path=$(dirname $0)

trap 'catch $? $LINENO' EXIT
catch() {
  if [ "$1" != "0" ]; then
    echo "Error $1 occurred on $2"
    gcloud projects remove-iam-policy-binding $project_id --member=serviceAccount:${terraform_service_account} --role=roles/cloudkms.cryptoOperator
  fi
}

simple() {
    gcloud projects add-iam-policy-binding $project_id --member=serviceAccount:${terraform_service_account} --role=roles/cloudkms.cryptoOperator

    python3 -m pip install --user --upgrade pip

    python3 -m pip install --user virtualenv

    python3 -m venv kms_helper_venv

    # shellcheck source=/dev/null
    source kms_helper_venv/bin/activate

    pip install --upgrade pip

    pip install -r $exe_path/wrapped-key/requirements.txt

    response_kms=$(python3 $exe_path/wrapped-key/wrapped_key.py --crypto_key_path ${key} --service_account ${terraform_service_account})

    echo "${response_kms}" | \
    gcloud secrets versions add "${secret_name}" \
    --data-file=- \
    --impersonate-service-account="${terraform_service_account}" \
    --project="${project_id}"

    gcloud projects remove-iam-policy-binding $project_id --member=serviceAccount:${terraform_service_account} --role=roles/cloudkms.cryptoOperator
}
simple
