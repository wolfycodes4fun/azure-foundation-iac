variable "environment" {
  type        = string
  description = "Name of the environment: dev/prod"
}

variable "region" {
  type        = string
  description = "Region where resource is located"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group"
}

variable "sql_version" {
  type        = string
  description = "Version of MS SQL"
}
