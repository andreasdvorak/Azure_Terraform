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

variable "responsibility" {
  description = "responsibility tag for resources"
  type        = string
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
