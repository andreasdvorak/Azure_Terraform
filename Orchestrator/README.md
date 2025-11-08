# Orchestrator
In here are the depending modules.

All use the same backend Terraform state file.

You need to create first the Azure Storage Account.

Note the outputs in the file backend.tf

Use the file run.sh to run terraform.
    ./run.sh [dev|test|prod] [plan|apply|destroy]

# Variables
All values for variables need to be set in the file
```
Orchestrator\env\<env>.tfvars
```

