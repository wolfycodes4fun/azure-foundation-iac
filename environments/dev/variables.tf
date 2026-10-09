variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "region" {
  type        = string
  description = "Deployment region for infrastructure"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "admin_password" {
  type        = string
  description = "Password for the admin user logging into the provisoned VMs"
  sensitive   = true
}

variable "sql_version" {
  type        = string
  description = "SQL version in the DB server"
}
