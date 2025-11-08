# Administration of EntraID
This project needs a service principal with more permissions.

It use a special backend Terraform state file. You need to create first the Azure Storage Account, with project Storage_Acccount.

Use the file run.sh to run terraform.
    ./run.sh [dev|test|prod] [plan|apply|destroy]

# Variables
All values for variables need to be set in the file
```
Manage_EntraID\env\<env>.tfvars
```

```
client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

backend_resource_group = "xxxxx"
backend_storage_account = "stXXXXXXXprod"
backend_storage_container = "tfstate"

environment_name = "prod"

tf_file_name = "entraid"
```