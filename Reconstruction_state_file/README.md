# State file reconstruction
In case that the Terraform state file is gone or parts are missing follow this guide.

For the reconstruction you need to import resouces manually.

# Preparation for local state file
Copy the file import.sh in the directory of you Terraform project, e.g. in the Orchestrator directory.

If your state file was in the Azure backup you need to disable the "backend" in the provider.tf.

## Create empty local state file

    terraform init

## Import
Without modules
    ./import.sh azurerm_resource_group.main rg-app-dev

In case you are using modules it looks like that.

    ./import.sh module.Linux_vm.azurerm_resource_group.main rg-app-dev