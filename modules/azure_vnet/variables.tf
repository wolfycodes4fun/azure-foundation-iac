variable "vnet_name" {
    type = string
    description = "Name of the virtual network"
}

variable "location" {
    type = string
    description = "Location of the virtual network"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group where the virtual network will be created"
}

variable "address_space" {
    type = list(string)
    description = "Address space for the virtual network"
    default = ["10.0.0.0/16"]
}