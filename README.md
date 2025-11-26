# Terraform code for Azure
Here you can find several projects to configure Azure with Terraform.

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

# Service Principals
I am using a service principal with high permissions for the administration of Identity Management and a second principal with lower permissions for resource managemant. The terraform-sp-id is create by the Azure Cli and the terraform-sp-rm by Terraform.

## Service principal Identity Management
This configuration needs to be done with Global Administrator.

https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group

To access Azure with Terraform you need a client_id and client_secret

Create a Service Principal

    az ad sp create-for-rbac --name "terraform-sp-id"

        {
    "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",         # → Client ID
    "displayName": "terraform-sp-id",
    "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",       # → Client Secret
    "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"          # → Tenant ID
    }

    APP_ID="<appId>"

In the Azure portal the SP can be seen in Microsoft Entra ID -> App registrations

Get Permission IDs

    az ad sp show --id 00000003-0000-0000-c000-000000000000 --query "oauth2PermissionScopes"

Get Role IDs

    az ad sp show --id 00000003-0000-0000-c000-000000000000 --query "appRoles"

00000003-0000-0000-c000-000000000000 = Microsoft Graph

Add permissions to SP
* User.ReadWrite.All (741f803b-c850-494e-b5df-cde7c675a1ca)
* Group.Create (bf7b1a76-6e77-406b-b258-bf5c7720e98f)
* Group.ReadWrite.All (62a82d76-70ea-41e2-9197-370581804d09)

    az ad app permission add \
    --id $APP_ID \
    --api 00000003-0000-0000-c000-000000000000 \
    --api-permissions bf7b1a76-6e77-406b-b258-bf5c7720e98f=Role 62a82d76-70ea-41e2-9197-370581804d09=Role df021288-bdef-4463-88db-98f22de89214=Role

Add Admin-Consent, this means an administrator gives permission for the API of an App.

    az ad app permission grant --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --scope "Group.ReadWrite.All"

# Application.ReadWrite.All
    az ad app permission add --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9=Role
    az ad app permission grant --id 1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9 --api 00000003-0000-0000-c000-000000000000 --scope "Application.ReadWrite.All"

# User.ReadWrite.All
    az ad app permission add --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 741f803b-c850-494e-b5df-cde7c675a1ca=Role
    az ad app permission grant --id 2dd11762-e032-4b28-bd1a-18285c9aba56 --api 00000003-0000-0000-c000-000000000000 --scope "User.ReadWrite.All"

Verify in Azure portal

Azure AD → App-Registrierungen → Deine App → API-Berechtigungen → Admin-Consent

Verify permission list

    az ad app permission list --id $APP_ID

## Add permissions to principal terraform-sp-rm
To give the terraform service principal the permission to create role assignments, we need to configure that first.

    az ad sp create-for-rbac --name "terraform-sp-id" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

    az role assignment create \
    --assignee "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \  # → Client ID
    --role "Privileged Role Administrator" \
    --scope "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Subscription ID

## Add permissions to principal terraform-sp-rm
To give the terraform service principal the permission to create role assignments, we need to configure that first.

    az role assignment create \
    --assignee "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \  # → Client ID
    --role "User Access Administrator" \
    --scope "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Subscription ID

# Code
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

# Verify code
Please check you code with the following command to have a nice and valid format in the files

    terraform fmt -recursive
