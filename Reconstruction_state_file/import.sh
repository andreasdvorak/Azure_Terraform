#/bin/bash

### variables ###


### main ###
if [ "$#" -lt 1 ]; then
    echo "Usage: import.sh <internal_resource_name> <resource_group_name>"
    exit 1
fi

ENV=$1
INTERNAL_RESOURCE_NAME=$2
RG_NAME=$3


SUBSCRIPTION_ID=$(grep "subscription_id" ../secrets.tfvars | cut -d "=" -f2 | tr -d '"' | tr -d ' ')

terraform import -var-file="./env/${ENV}.tfvars" -var-file="../secrets.tfvars" \
    ${INTERNAL_RESOURCE_NAME} /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RG_NAME}
