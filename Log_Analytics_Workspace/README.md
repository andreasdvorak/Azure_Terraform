# Setup Azure Log Analytics Workspace
This code create a Azure Log Analytics Workspace.

Use Azure as backend for state file

You can put this in the provider.tf file

```
backend "azurerm" {
  resource_group_name  = "<resource_group_name>"
  storage_account_name = "<storage_account_name>"
  container_name       = "<container_name>"
  key                  = "terraform.tfstate"
}
```

or the shell script and put the values in the <env>.tfvars file

  run.sh <env> <action>

Example: dev.tfvars

```
application_name=observability

backend_resource_group=
backend_storage_account=
backend_storage_container=

environment_name=dev

subscription_id=
```

# Create Azure storage
To store the Terraform state file you need three things

- resource group
- storage account
- storage container

## Create Azure Storage account
    ./azure_storage.sh

## Configure terraform backend
Get the storage access key

    export RESOURCE_GROUP_NAME=
    export STORAGE_ACCOUNT_NAME=
    ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
    export ARM_ACCESS_KEY=$ACCOUNT_KEY


## provider.tf
Insert the real name here. You can find it in the script output or in the Azure portal.

storage_account_name = "<storage_account_name>"

# Details to the state file
At the end of the Terraform state file is appended
"env:<env>"
to link the correct state file to the environment.
