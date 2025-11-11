variable "backend_resource_group" {
  description = "backend resource group"
  type        = string
}

variable "backend_storage_account" {
  description = "backend storage account"
  type        = string
}

variable "backend_storage_container" {
  description = "backend storage container"
  type        = string
}

variable "client_id" {
  description = "client id for azure"
  type        = string
}

variable "client_secret" {
  description = "client secret for azure"
  type        = string
}

# The name of the container of the storage account
variable "container_name" {
  description = "The name of the container of the storage account"
  type        = string
}

variable "env" {
  description = "Environment of vms (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(local.allowed_environments, var.env)
    error_message = "The variable 'env' muss be 'dev', 'test' or 'prod'."
  }
}

variable "location" {
  description = "Azure Region für die Bereitstellung"
  type        = string
  default     = "westeurope"

  validation {
    condition     = contains(local.allowed_locations, var.location)
    error_message = "not valid region. Allowed are: ${join(", ", local.allowed_locations)}"
  }
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}


variable "subscription_id" {
  description = "subscription id for azure"
  type        = string
}

variable "tenant_id" {
  description = "tenant id for azure"
  type        = string
}

