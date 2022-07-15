provider "azurerm" {
  features {}
}

resource "random_string" "random_id" {
 length = 6
 special = false
 upper = false
 numeric = false
}

resource "azurerm_resource_group" "main" {
  name = "${var.prefix}-rg"
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "main" {
  name = "${var.prefix}-network"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = var.tags
}

resource "azurerm_subnet" "internal" {
  name = "${var.prefix}-subnet"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.2.0/24"]
}

# backend load balancer resources
resource "azurerm_public_ip" "backend" {
  name = "${var.prefix}-backend-public-ip"
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method = "Static"
  domain_name_label = random_string.random_id.result
  tags = var.tags
}

resource "azurerm_lb" "backend" {
  name = "${var.prefix}-backend-lb"
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = var.tags

  frontend_ip_configuration {
    name = "${var.prefix}-backend-public-ip-address"
    public_ip_address_id = azurerm_public_ip.backend.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  name = "${var.prefix}-backend-address-pool"
  loadbalancer_id = azurerm_lb.backend.id
}

resource "azurerm_lb_nat_pool" "backend" {
  name = "${var.prefix}-backend-nat-pool"
  resource_group_name = var.image_resource_group_name
  loadbalancer_id = azurerm_lb.backend.id
  frontend_port_start = 50000
  frontend_port_end = 50100
  backend_port = 22
  protocol = "Tcp"
  idle_timeout_in_minutes = 4
  floating_ip_enabled = false
  tcp_reset_enabled = false
  frontend_ip_configuration_name = "${var.prefix}-backend-public-ip-address"
}

resource "azurerm_lb_probe" "backend" {
  name = "${var.prefix}-backend-ssh-running-probe"
  loadbalancer_id = azurerm_lb.backend.id
  port = var.application_port
}

resource "azurerm_lb_rule" "backend" {
  name = "${var.prefix}-backend-http-rule"
  loadbalancer_id = azurerm_lb.backend.id
  protocol = "Tcp"
  frontend_port = var.application_port
  backend_port = var.application_port
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend.id]
  frontend_ip_configuration_name = "${var.prefix}-backend-public-ip-address"
  probe_id = azurerm_lb_probe.backend.id
}
# ---

data "azurerm_image" "image" {
  name = var.image_name
  resource_group_name = var.image_resource_group_name
}

resource "azurerm_network_security_group" "main" {
  name = "${var.prefix}-nsg"
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name = "SSH"
  priority = 1001
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "http" {
  name = "HTTP"
  priority = 1002
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "80"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name = "${var.prefix}-vmscaleset"
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku = "Standard_B1s"
  instances = var.vm_count
  admin_username = var.username
  disable_password_authentication = true
  source_image_id = data.azurerm_image.image.id
  tags = var.tags

  admin_ssh_key {
    username   = var.username
    public_key = file("id_rsa.pub")
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }

  network_interface {
    name = "${var.prefix}-networkprofile"
    primary = true
    network_security_group_id = azurerm_network_security_group.main.id

    ip_configuration {
      name = "${var.prefix}-vmscaleset-networkprofile-ip-configuration"
      subnet_id = azurerm_subnet.internal.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend.id]
      load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.backend.id]
      primary = true
    }
  }
}
