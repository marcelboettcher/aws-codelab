#!/usr/bin/env bash

set -e -o pipefail

if [[ -z "${1}" ]]; then
    echo "Use environment as first argument"
    exit 1
fi

if [[ -z "${2}" ]]; then
    echo "No aws profile set as second argument. Using 'default' as profile."
fi

ENV="${1}"
PROFILE="${2:-default}"
SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"

pushd ${SCRIPT_DIR}/../terraform

terraform apply -var-file environments/${ENV}.tfvars -var "profile=${PROFILE}"

popd