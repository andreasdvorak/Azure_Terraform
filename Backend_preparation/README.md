# Store the Terraform state in Azure
This prepares Azure to store a terraform.state file.

You can choose different Terraform workspaces for dev, test and prod.

To use the Azure blobstorage for the state file you need to configure a backend "azurerm" in the other project.

# Create Azure storage
To store the Terraform state file you need three things

- resource group
- storage account
- storage container


## Variables
All values for variables need to be set in the file
```
Backend_preparation\env\<env>.tfvars
```

```
client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

backend_resource_group = "xxxxx"
backend_storage_account = "stXXXXXXXyyyy"
backend_storage_container = "<name>"

environment_name = "<environment>"

location = "<location>"

responsibility = "<responsibility>"
```

## Create Azure Storage account
You can run this script
    ./azure_storage.sh [dev|test|prod]


You use Terraform with a local state file to create the storage account. Than you have the problem of the local state file and you can not set "allow-blob-public-access" via Terraform.

    terraform [plan|apply|destroy] -var-file="./env/dev.tfvars" -var-file=../secrets.tfvars

Use the outputs to for other Terraform project to use the Azure backend for the Terraform state file.
