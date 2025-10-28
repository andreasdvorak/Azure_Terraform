variable "admin_username" {
    description = "admin username for Ubuntu"
    type = string

    validation {
        condition = length(var.admin_username) > 5
        error_message = "admin username too short (>5)"
    }
}

variable "admin_password" {
    description = "admin password for Ubuntu"
    type = string
    sensitive = true

    validation {
        condition = length(var.admin_password) > 6
        error_message = "admin username too short (>6)"
    }
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  default     = "vm-grp"
}

variable "client_id" {
    description = "client id for azure"
    type = string
}

variable "client_secret" {
    description = "client secret for azure"
    type = string
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

variable "number_of_subnets" {
    default = 1
    description = "number of subnets"
    type = number
    validation {
      condition = var.number_of_subnets < 5
      error_message = "The number of subnets must be less than 5"
    }
}

variable "number_of_vms" {
    default = 1
    description = "number of vms"
    type = number
    validation {
      condition = var.number_of_vms >= local.min_vms && var.number_of_vms < local.max_vms
      error_message = "The number of vms must be less than ${local.max_vms}"
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

variable "subscription_id" {
    description = "subscription id for azure"
    type = string
}

variable "tenant_id" {
    description = "tenant id for azure"
    type = string
}

variable "virtual_network" {
  description = "Konfiguration für das virtuelle Netzwerk"
  type = object({
    name          = string
    address_space = string
  })

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.virtual_network.address_space))
    error_message = "Die address_space muss im CIDR-Format sein, z. B. 10.0.0.0/16."
  }
}

