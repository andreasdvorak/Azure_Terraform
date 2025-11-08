variable "application_name" {
  default     = "test"
  description = "Log Analytics application name"
  type        = string
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
  description = "Azure region for deployment"
  type        = string
  default     = "westeurope"

  validation {
    condition     = contains(local.allowed_locations, var.location)
    error_message = "not valid region. Allowed are: ${join(", ", local.allowed_locations)}"
  }
}
