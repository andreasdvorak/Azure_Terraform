variable "admin_username" {
  default     = "test"
  description = "Administrator user name"
  type        = string
}

variable "application_name" {
  default     = "test"
  description = "Application name"
  type        = string
}

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

variable "keyvault_application_name" {
  default     = "test"
  description = "KeyVault application name"
  type        = string
}

variable "log_analytics_workspace_application_name" {
  default     = "test"
  description = "Log Analytics application name"
  type        = string
}

variable "network_application_name" {
  default     = "test"
  description = "Network application name"
  type        = string
}

variable "os_offer" {
  description = "os to offer"
  type        = string
}

variable "os_sku" {
  description = "os sku"
  type        = string
}

variable "subscription_id" {
  description = "subscription id for azure"
  type        = string
}

variable "tenant_id" {
  description = "tenant id for azure"
  type        = string
}

variable "tf_file_name" {
  type = string
}

variable "virtual_network" {
  description = "Konfiguration für das virtuelle Netzwerk"
  type = object({
    name           = string
    address_space  = string
    subnet_newbits = number
  })

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.virtual_network.address_space))
    error_message = "Die address_space muss im CIDR-Format sein, z. B. 10.0.0.0/16."
  }
}

variable "vm_application_name" {
  default     = "test"
  description = "VM application name"
  type        = string
}