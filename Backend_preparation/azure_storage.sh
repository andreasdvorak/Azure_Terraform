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

# Create resource group
az group list | grep ${BACKEND_RESOURCE_GROUP} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Resource group ${BACKEND_RESOURCE_GROUP} already exists"
else
    az group create --name ${BACKEND_RESOURCE_GROUP} --location ${LOCATTION}
fi

# Create storage account
az storage account list | grep ${BACKEND_STORAGE_ACCOUNT} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Storage account ${BACKEND_STORAGE_ACCOUNT} already exists"
else
    az storage account create --resource-group ${BACKEND_RESOURCE_GROUP} --name ${BACKEND_STORAGE_ACCOUNT} --sku Standard_LRS --encryption-services blob
fi

# Create blob container
az storage container list --account-name ${BACKEND_STORAGE_ACCOUNT} | grep ${BACKEND_STORAGE_CONTAINER} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Blob container ${BACKEND_STORAGE_CONTAINER} already exists"
    exit 0
else
    az storage container create --name ${BACKEND_STORAGE_CONTAINER} --account-name ${BACKEND_STORAGE_ACCOUNT}
fi

# Azure does not have a Terraform code, to deactviate anonymous access on acccount level:
az storage account update \
  --name ${BACKEND_STORAGE_ACCOUNT} \
  --resource-group ${BACKEND_RESOURCE_GROUP} \
  --allow-blob-public-access false

az storage account update \
  --name ${BACKEND_STORAGE_ACCOUNT} \
  --resource-group ${BACKEND_RESOURCE_GROUP} \
  --allow-shared-key-access true