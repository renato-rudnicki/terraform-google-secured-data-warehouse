#!/usr/bin/env bash

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

set -e

#function compare(){
echo "Preparing provider" > test/fixtures/standalone/providers.tf
config1="examples/standalone/providers.tf"
config2="test/fixtures/standalone/providers.tf"
if cmp -s "$config1" "$config2"; then
    echo "${config1} and ${config2} are the same"
else
    echo "${config1} and ${config2} differ"
    #
    cp examples/standalone/providers.tf test/fixtures/standalone/providers.tf
    mv examples/standalone/providers.tf examples/standalone/providers.tf.disabled
#    exit 1
fi
#}

#function prepare(){
    # assert provider.tf in network envs are same
#    compare examples/standalone/providers.tf  test/fixtures/standalone/providers.tf

    # copy one config to network fixture
#    cp examples/standalone/providers.tf test/fixtures/standalone/providers.tf

    # disable provider configs in main module
#    mv examples/standalone/providers.tf examples/standalone/providers.tf/providers.tf.disabled
#}

#function restore(){
    # remove test provider config
#    rm -rf test/fixtures/standalone/providers.tf
    # replace original provider config
    # disable provider configs in main module
#    mv examples/standalone/providers.tf.disabled examples/standalone/providers.tf
#    echo "aaa" >> examples/standalone/providers.tf
#}


# parse args
# for arg in "$@"
# do
#   case $arg in
#     -p|--prepare)
#       prepare
#       shift
#       ;;
#     -r|--restore)
#       restore
#       shift
#       ;;
#       *) # end argument parsing
#       shift
#       ;;
#   esac
# done

