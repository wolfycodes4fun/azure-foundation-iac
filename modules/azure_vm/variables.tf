variable "nic_name" {
  type        = string
  description = "Name of the NIC associated with the VM"
}

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "vm_size" {
  type        = string
  description = "Virtual machine size"
  default     = "Standard_D4_v5"
}

variable "admin_username" {
  type        = string
  description = "Username for admin user for VM"
  default     = "admin"
}

variable "admin_password" {
  type        = string
  description = "Password for the admin user mentioned above"
}

variable "region" {
  type        = string
  description = "Location of the Virtual Machine"
}

variable "zones" {
  type        = list(string)
  description = "List of availability zones for the region specified"
  default     = ["1", "2", "3"]
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group which VM belongs to"
}

variable "environment" {
  type = string
}

variable "pvt_subnet_id" {
  type        = string
  description = "ID of subnet which the VM is attached to"
}