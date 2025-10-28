variable "application_name" {
  default     = "test"
  description = "Application name"
  type = string
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
  description = "Environment of vms (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(local.allowed_environments, var.environment_name)
    error_message = "The variable 'environment_name' muss be 'dev', 'test' or 'prod'."
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