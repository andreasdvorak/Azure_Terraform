# Administration of Polices
This project needs a service principal with more permissions.

It use a special backend Terraform state file. You need to create first the Azure Storage Account, with project Storage_Acccount.

Use the file run.sh to run terraform.
    ./run.sh [dev|test|prod] [plan|apply|destroy]

# VM sizes
https://docs.azure.cn/en-us/virtual-machines/sizes/overview?tabs=breakdownseries%2Cgeneralsizelist%2Ccomputesizelist%2Cmemorysizelist%2Cstoragesizelist%2Cgpusizelist%2Chpcsizelist

# SP permissions
To allow the Terraform service principal "terraform-sp-id" to set policies you need to set these.


    az role assignment create \
    --assignee <SERVICE_PRINCIPAL_ID> \
    --role "Reader" \
    --scope "/subscriptions/<SUBSCRIPTION_ID>"

    az role assignment create \
    --assignee <SERVICE_PRINCIPAL_ID> \
    --role "Resource Policy Contributor" \
    --scope "/subscriptions/<SUBSCRIPTION_ID>"

Verify
    az role assignment list --assignee "<SERVICE_PRINCIPAL_ID>"

In the Azure Portal go to the subscription -> Access control (IAM) -> Role Assignments

# Variables
All values for variables need to be set in the file
```
Manage_EntraID\env\<env>.tfvars
```

```
allowed_regions = [
  "northeurope",
  "westeurope",
  "germanywestcentral",
  "germanynorth",
  "francecentral",
  "francesouth"
]

allowed_vm_sizes = [
  "Standard_B1s",
  "Standard_B2s",
  "Standard_A1_v2"
]

client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

backend_resource_group = "xxxxx"
backend_storage_account = "stXXXXXXXprod"
backend_storage_container = "tfstate"

environment_name = "prod"

tf_file_name = "policies"
```

You can find the policies in the Azure portal at the subscription -> Policy