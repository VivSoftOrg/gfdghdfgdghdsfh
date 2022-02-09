#!/usr/bin/env bash

set -eu -o pipefail

TFVAR_FILE="infra/tfvars.json"
STACK_NAME=${PWD##*/}
STACK_NAME=${STACK_NAME%%+([[:digit:]])} # Remove any digit's.
STACK_NAME=${STACK_NAME//-/} # Remove any hyphens
STACK_NAME=${STACK_NAME//_/} # Remove any hyphens
STACK_NAME=${STACK_NAME:0:23} # Azure impose  only 24 char limit on storage account

# login to Azure first
az login --service-principal -u "${ARM_CLIENT_ID}" -p="${ARM_CLIENT_SECRET}" -t "${ARM_TENANT_ID}"

if [[ $(jq '.prefix | length > 0' < "${TFVAR_FILE}") != "true" ]]; then
    if [[ $(jq '.client_code | length > 0' < "${TFVAR_FILE}") != "true" ]]; then
        echo "client_code should not be empty"
        exit 1
    fi
    if [[ $(jq '.product | length > 0' < "${TFVAR_FILE}") != "true" ]]; then
        echo "product should not be empty"
        exit 1
    fi
fi
PREFIX=$(jq -r 'if (.prefix | length > 0) then (.prefix | ascii_downcase) else (.client_code | ascii_downcase) + "-" + (if (.environment | length > 0) then (.environment | ascii_downcase) else "prod" end) + "-" + (.product | ascii_downcase) end' < "${TFVAR_FILE}")

PREFIX="$PREFIX-state" #Since in LZ we also create the Resource Group , the name collision happens; So appending state.

if [[ $(jq '.location | length > 0' < "${TFVAR_FILE}") != "true" ]]; then
    echo "location should not be empty"
    exit 1
fi
LOCATION=$(jq -r '.location' < "${TFVAR_FILE}")


echo "Delete the Resource Group ${PREFIX}"

if [[ $(az group list --query "[?name=='${PREFIX}']" | jq '. | length > 0') != "true" ]]; then
    echo "Resource group ${PREFIX} at location ${LOCATION} does not exist."
else
    az group delete --name "${PREFIX}"  --yes
fi