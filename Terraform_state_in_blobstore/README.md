# Store the Terraform state in Azure
This prepares Azure to store a terraform.state file.

You can choose different Terraform workspaces for dev, test and prod.

To use the Azure blobstorage for the state file you need to configure a backend "azurerm" in an other project.

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

# Code
## client access values
To access Azure with Terraform you need a client_id and client_secret

Create a Service Principal e.g. terraform in https://entra.microsoft.com

    az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"


    {
    "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",         # → Client ID
    "displayName": "terraform-sp",
    "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",       # → Client Secret
    "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"          # → Tenant ID
    }

In the Azure portal the SP can be seen in Microsoft Entra ID -> App registrations

## tfvars
In the directory env put your environment specific tfvars files.

These files should not be put in git, because they contain secrets.

Check .gitignore

* dev.tfvars
* prod.tfvars

Example
This file should not be put in git, because it contains secrets.
```
client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## Test of SP with az login

    az login --service-principal \
            --username <APP_ID> \
            --password <CLIENT_SECRET> \
            --tenant <TENANT_ID>

## locals.tf
put in here all values, but no secrets

## provider.tf
Insert the real name here. You can find it in the script output or in the Azure portal.

storage_account_name = "<storage_account_name>"
