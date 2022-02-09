#!/usr/bin/env bash

set -eu -o pipefail

TFVAR_FILE="infra/tfvars.json"
STACK_NAME=${PWD##*/}
STACK_NAME=${STACK_NAME%%+([[:digit:]])} # Remove any digit's.
STACK_NAME=${STACK_NAME//-/} # Remove any hyphens
STACK_NAME=${STACK_NAME//_/} # Remove any hyphens
STACK_NAME=${STACK_NAME:0:23} # Azure impose  only 24 char limit on storage account
STACK_NAME=$(echo "$STACK_NAME" | awk '{print tolower($0)}') # Storage account only lower case

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


if [[ $(az group list --query "[?name=='${PREFIX}']" | jq '. | length > 0') != "true" ]]; then
    echo "creating resource group ${PREFIX} at location ${LOCATION}"
    az group create --name "${PREFIX}" --location "${LOCATION}"
else
    echo "Resource group ${PREFIX} at location ${LOCATION} already exist."
fi


if [[ $(az storage account list -g ${PREFIX} --query "[?name=='${STACK_NAME}']" | jq '. | length > 0') != "true" ]]; then
    echo "creating storage account ${STACK_NAME} in resource group ${PREFIX}"
    az storage account create --resource-group "${PREFIX}" --name "${STACK_NAME}" --sku Standard_LRS --encryption-services blob
else
  echo "storage account ${STACK_NAME} in resource group ${PREFIX} already exist."
fi

if [[ $(az storage container list --account-name "${STACK_NAME}" --query "[?name=='tfstate']" 2>/dev/null | jq '. | length > 0') != "true" ]]; then
    echo "creating container tfstate in storage account ${STACK_NAME} in resource group ${PREFIX}"
    az storage container create --name tfstate --account-name "${STACK_NAME}"
else
    echo "container tfstate in storage account ${STACK_NAME} in resource group ${PREFIX} already exist."
fi


echo "::set-output name=STORAGE_ACCOUNT::${STACK_NAME}"
echo "::set-output name=CONTAINER_NAME::tfstate"
echo "::set-output name=RESOURCE_GROUP::${PREFIX}"