variable "admin_username" {
  default     = "test"
  description = "Administrator user name"
  type = string
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  default     = "vm-grp"
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

variable "os_offer" {
    description = "os to offer"
    type = string
}

variable "os_sku" {
    description = "os sku"
    type = string
}