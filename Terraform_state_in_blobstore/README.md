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
You can run this script
    ./azure_storage.sh

or use Terraform to create the storage account.

Use the outputs to for other Terraform project to use the Azure backend for the Terraform state file.

