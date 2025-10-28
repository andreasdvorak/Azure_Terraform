#/bin/bash

env=$1

# set the subscription
export ARM_SUBSCRIPTION_ID=$(grep "subscription_id" env/${env}.tfvars | cut -d "=" -f2)

# set the application and environment
export TF_VAR_application_name=$(grep "application_name" env/${env}.tfvars | cut -d "=" -f2)
export TF_VAR_environment_name=${env}

# set the backend
export BACKEND_RESOURCE_GROUP=$(grep "backend_resource_group" env/${env}.tfvars | cut -d "=" -f2)
export BACKEND_STORAGE_ACCOUNT=$(grep "backend_storage_account" env/${env}.tfvars | cut -d "=" -f2)
export BACKEND_STORAGE_CONTAINER=$(grep "backend_storage_container" env/${env}.tfvars | cut -d "=" -f2)
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${export BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*