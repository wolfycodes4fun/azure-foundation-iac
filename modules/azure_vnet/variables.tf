variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "location" {
  type        = string
  description = "Location of the virtual network"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the virtual network will be created"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "pvt_subnet_name" {
  type        = string
  description = "Name of the private subnet"
}

variable "pvt_subnet_address_space" {
  type        = list(string)
  description = "Address space for the private subnet"
  default     = ["10.0.1.0/24"]
}

variable "public_subnet_name" {
  type        = string
  description = "Name of the public subnet"
}

variable "public_subnet_address_space" {
  type        = list(string)
  description = "Address space for the public subnet"
  default     = ["10.0.2.0/24"]
}