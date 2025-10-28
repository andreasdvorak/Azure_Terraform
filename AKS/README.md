# Azure Kubernetes
Set up a small and free Kubernetes Cluster in Azure with Terraform

You can only define the number of worker. The number of Control Planes is created by Azure automatically redundant.

# AKS Administration
## Get kubeconfig
Login with az

    az login

Get kubeconfig

    az aks get-credentials --resource-group <RESOURCE_GROUP_NAME> --name <AKS_CLUSTER_NAME>

## Test

    kubectl get nodes

## Created resource groups and resources

The resource group rg-<resource_group_name> has been defined in the Terraform code. Here is only one resource for the Kubernetes service.

The resource group MC_<resource_group_name>_<AKS-Name>_<Region> is created automatically by Azure. You can only see it, but not remove it.





