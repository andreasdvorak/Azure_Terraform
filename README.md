# Terraform code for Azure
Here you can find several projects to create Azure resources.

# Terraform installation
https://developer.hashicorp.com/terraform/install#linux

# Preparations
## Azure CLI
Installation of Azure CLI

    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## az login
To run the terraform apply you first need to login at Azure

    az login

## Get Azure Regions
    az account list-locations -o table

## List Subscriptions
    az account list

## Show Subscription

    az account show

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

## Add permissions to principal
To give the terraform service principal the permission to create role assignments, we need to configure that first.

    az role assignment create \
    --assignee "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \  # → Client ID
    --role "User Access Administrator" \
    --scope "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Subscription ID


## tfvars
In the directory env put your environment specific tfvars files.

These files should not be put in git, because they contain secrets.

Check .gitignore

* dev.tfvars
* prod.tfvars

In the main directory, I recommend a file secrets.tfvars like this with the Azure credentials.

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

# Terraform commands
## initialze Terraform
    terraform init [-upgrade]

If you want to use new versions of providers you need the "-upgrade".

## Terraform workspace
With workspace you can switch between different tfvars and the corresponding tfstate files.

    terraform workspace list

    terraform workspace new dev

## Terraform Validate
    terraform validate

## Create a Terraform execution plan
    terraform plan -var-file="./env/dev.tfvars" -var-file=../secrets.tfvars

## Execute Terraform
    terraform apply -var-file="./env/dev.tfvars" -var-file=../secrets.tfvars

## delete all remote objets
    terraform destroy -var-file="./env/dev.tfvars" -var-file=../secrets.tfvars

## Terrform console
With the Terraform console you can get information about variables or resources.

    terraform console -var-file="./env/dev.tfvars" -var-file=../secrets.tfvars
    azurerm_resource_group.main
    random_uuid.appvaultkey

## Environment variables for debugging
    $env:TF_LOG="DEBUG"
    $env:TF_LOG_PATH="terraform.log"
