resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.region}-${var.environment}-rg"
  location = var.region
}

module "azure_vnet" {
  source = "../../modules/azure_vnet"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  project_name        = var.project_name

  # Private subnet configuration
  pvt_subnet_name = "${var.region}-${var.environment}-pvt-subnet"

  # Public subnet configuration
  public_subnet_name = "${var.region}-${var.environment}-public-subnet"
}

module "azure_vm" {
  source = "../../modules/azure_vm"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment

  # VM configuration
  vm_size        = "Standard_D2as_v4"
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  zones          = ["1", "2"]

  # NIC configuration
  pvt_subnet_id = module.azure_vnet.private_subnet_id
}

module "azure_lb" {
  source = "../../modules/azure_lb"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Load balancer configuration
  pip_name    = "${var.project_name}-${var.environment}-lb-pip1"
  app_lb_name = "${var.project_name}-${var.environment}-lb"
  nics        = module.azure_vm.nics
}

module "azure_sql" {
  source = "../../modules/azure_sql"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment

  # SQL Server instance configuration
  sql_version = var.sql_version
}

module "azure_storage" {
  source = "../../modules/azure_storage"

  project_name        = var.project_name
  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.root}/../../ansible/templates/hosts.tpl",
    {
      bastion_ip    = module.azure_vnet.bastion_host_ip
      az_vm_pvt_ips = module.azure_vm.nics[*].private_ip_address
      ssh_user      = var.admin_username
  })
  filename = "${path.root}/../../ansible/hosts.ini"
}
