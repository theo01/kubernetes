#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A library of helper functions for CoreOS.

SSH_USER=ubuntu


function detect-coreos-image () {
  if [[ -z "${AWS_IMAGE-}" ]]; then
    AWS_IMAGE=$(curl -s -L http://${COREOS_CHANNEL}.release.core-os.net/amd64-usr/current/coreos_production_ami_all.json | python -c "import json,sys;obj=json.load(sys.stdin);print filter(lambda t: t['name']=='${AWS_REGION}', obj['amis'])[0]['hvm']")
  fi
  if [[ -z "${AWS_IMAGE-}" ]]; then
    echo "unable to determine AWS_IMAGE"
    exit 2
  fi
}

function detect-minion-image() {
  if [[ -z "${KUBE_MINION_IMAGE=-}" ]]; then
    detect-image
    KUBE_MINION_IMAGE=$AWS_IMAGE
  fi
}

function generate-master-user-data() {
  cat "${KUBE_ROOT}/cluster/aws/coreos/master"
}

function generate-minion-user-data() {
  cat "${KUBE_ROOT}/cluster/aws/coreos/node"
}

function check-minion() {
  echo "working"
}

function yaml-quote {
  echo "'$(echo "${@}" | sed -e "s/'/''/g")'"
}
