
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "supervisor_ssh_public_key" {
  description = "Path to the supervisor's SSH public key file"
  type        = string
}

variable "computer_name" {
  description = "Name of the computer"
  type        = string
  default     = "myvm"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "disable_password_authentication" {
  description = "Disable password authentication for the VM"
  type        = bool
  default     = true
}
