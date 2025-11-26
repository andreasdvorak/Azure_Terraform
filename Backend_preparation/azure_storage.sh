#!/bin/bash

### variables ###
locals_file="locals.tf"

### main ###
# get environments from file
line=$(grep "allowed_environments" "$locals_file")
values=$(echo "$line" | sed -E 's/.*\[(.*)\].*/\1/')
values=$(echo "$values" | tr -d '"')
IFS=', ' read -ra envs <<< "$values"

if [ "$#" -lt 1 ]; then
    echo "Error: You need to add the environment."
    echo "Possible: ${envs[*]}"
    exit 1
fi

env=$1

if printf '%s\n' "${envs[@]}" | grep -q "^${env}$"; then
    echo "Starting ...."
else
    echo "Error: Not allowed env. Use : ${envs[*]}"
    exit 1
fi

BACKEND_RESOURCE_GROUP=$(grep "backend_resource_group" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
BACKEND_STORAGE_ACCOUNT=$(grep "backend_storage_account" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
BACKEND_STORAGE_CONTAINER=$(grep "backend_storage_container" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
LOCATTION=$(grep "location" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
RESPONSIBILITY=$(grep "responsibility" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')

# Create resource group
echo "Creating resource group: ${BACKEND_RESOURCE_GROUP} in location: ${LOCATTION}"
az group list | grep ${BACKEND_RESOURCE_GROUP} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Resource group ${BACKEND_RESOURCE_GROUP} already exists"
else
    az group create \
    --name ${BACKEND_RESOURCE_GROUP} \
    --location ${LOCATTION} \
    --tags environment=${env} responsibility=${RESPONSIBILITY}
fi

# Create storage account
echo "Creating storage account: ${BACKEND_STORAGE_ACCOUNT}"
az storage account list | grep ${BACKEND_STORAGE_ACCOUNT} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Storage account ${BACKEND_STORAGE_ACCOUNT} already exists"
else
    az storage account create \
    --resource-group ${BACKEND_RESOURCE_GROUP} \
    --name ${BACKEND_STORAGE_ACCOUNT} \
    --sku Standard_LRS \
    --encryption-services blob
fi


# Get Account Key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group ${BACKEND_RESOURCE_GROUP} \
  --account-name ${BACKEND_STORAGE_ACCOUNT} \
  --query "[0].value" -o tsv)

# Create blob container
echo "Creating blob container: ${BACKEND_STORAGE_CONTAINER}"
az storage container list \
--account-name ${BACKEND_STORAGE_ACCOUNT} \
--account-key ${ACCOUNT_KEY} \
--query "[?name=='${BACKEND_STORAGE_CONTAINER}']" -o tsv | grep ${BACKEND_STORAGE_CONTAINER} > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Blob container ${BACKEND_STORAGE_CONTAINER} already exists"
    exit 0
else
    az storage container create \
    --name ${BACKEND_STORAGE_CONTAINER} \
    --account-name ${BACKEND_STORAGE_ACCOUNT} \
    --account-key ${ACCOUNT_KEY}
fi

# Azure does not have a Terraform code, to deactviate anonymous access on acccount level:
echo "Disabling anonymous access to storage account: ${BACKEND_STORAGE_ACCOUNT}"
az storage account update \
  --name ${BACKEND_STORAGE_ACCOUNT} \
  --resource-group ${BACKEND_RESOURCE_GROUP} \
  --allow-blob-public-access false

echo "Enabling shared key access to storage account: ${BACKEND_STORAGE_ACCOUNT}"
az storage account update \
  --name ${BACKEND_STORAGE_ACCOUNT} \
  --resource-group ${BACKEND_RESOURCE_GROUP} \
  --allow-shared-key-access true