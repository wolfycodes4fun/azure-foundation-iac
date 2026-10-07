variable "region" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "pip_name" {
  type        = string
  description = "Public IP address which will be associated with the LB"
}

variable "app_lb_name" {
  type        = string
  description = "Frontend application load balancer"
}

variable "be_pool_name" {
  type        = string
  description = "Backend address pool name for frontend LB"
  default = "pool1"
}

variable "nic_ids" {
  type        = list(string)
  description = "List of NICs that will be a part of the backend pool"
}