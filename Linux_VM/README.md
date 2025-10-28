# Create a Linux VM in Azure with Terraform
With this code you can create several vms with Linux.

All we be in the same subnet.

You can choose different Terraform workspaces for dev, test and prod.



## tfvars
In the directory env put your environment specific tfvars files.

These files should not be put in git, because they contain secrets.

Check .gitignore

* dev.tfvars
* prod.tfvars

Example
This file should not be put in git, because it contains secrets.
```
number_of_subnets = 1
number_of_vms = 2

os_offer = "0001-com-ubuntu-server-jammy"
os_sku   = "22_04-lts-gen2"

admin_username = "master"
admin_password = "password"

env = "dev"

virtual_network={
    name="app-network"
    address_space="10.0.1.0/24"
}
```

# Access VM with ssh
With the following command you should be able to access the vm

    ssh -i ${local_file.ssh_privat_key.filename} ${var.admin_username}@${azurerm_public_ip.appip.ip_address} -o StrictHostKeyChecking=no -o IdentitiesOnly=yes
