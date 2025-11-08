#/bin/bash

### variables ###
locals_file="locals.tf"
envs=()
actions=("plan" "apply" "destroy")

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
    echo "Starting terraform init"
else
    echo "Error: Not allowed env. Use : ${envs[*]}"
    exit 1
fi

# set the subscription
export ARM_SUBSCRIPTION_ID=$(grep "subscription_id" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')

# set the application and environment
export TF_VAR_tf_file_name=$(grep "tf_file_name" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
export TF_VAR_environment_name=${env}

# set the backend
export BACKEND_RESOURCE_GROUP=$(grep "backend_resource_group" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
export BACKEND_STORAGE_ACCOUNT=$(grep "backend_storage_account" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
export BACKEND_STORAGE_CONTAINER=$(grep "backend_storage_container" env/${env}.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')
export BACKEND_KEY=${TF_VAR_tf_file_name}-${TF_VAR_environment_name}.tfstate

terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"

action=$2

if [ "${action}" == "" ]
then
    echo "No action set"
    exit 1
else
    if printf '%s\n' "${actions[@]}" | grep -q "^${action}$"; then
        echo "Starting terraform $action"
    else
        echo "Error: Not allowed action. Use : ${actions[*]}"
        exit 1
    fi
fi

terraform $action -var-file="./env/${env}.tfvars"

rm -rf .terraform