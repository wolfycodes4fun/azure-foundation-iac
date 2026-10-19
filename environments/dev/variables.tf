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

variable "admin_username" {
  type        = string
  description = "Username for the admin user logging into the provisoned VMs"
  sensitive   = true
}

variable "ssh_key_path" {
  type        = string
  description = "Public SSH key used to authenticate with AZ VMs"
  sensitive   = true
}

variable "sql_version" {
  type        = string
  description = "SQL version in the DB server"
}
