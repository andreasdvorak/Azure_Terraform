variable "allowed_regions" {
  type        = list(string)
  description = "List of allowed Azure regions"
}

variable "allowed_vm_sizes" {
  type        = list(string)
  description = "List of allowed VM sizes"
}

variable "backend_resource_group" {
  description = "backend resource group"
  type = string
}

variable "backend_storage_account" {
  description = "backend storage account"
  type = string
}

variable "backend_storage_container" {
  description = "backend storage container"
  type = string
}

variable "client_id" {
    description = "client id for azure"
    type = string
}

variable "client_secret" {
    description = "client secret for azure"
    type = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(local.allowed_environments, var.environment_name)
    error_message = "The variable 'environment_name' is not valid. Allowed are: ${join(", ", local.allowed_environments)}"
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

variable "subscription_id" {
    description = "subscription id for azure"
    type = string
}

variable "tenant_id" {
    description = "tenant id for azure"
    type = string
}

variable "tf_file_name" {
  type = string
}
