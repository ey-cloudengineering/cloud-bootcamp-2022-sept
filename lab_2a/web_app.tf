terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.23.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "applcation_network" {
  name                = "${var.name}-lab-2a-network"
  address_space       = ["${var.subnet_allocated}"]
  location            = "australiaeast"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "lab_application_subnet" {
  name                 = "${var.name}_lab_application_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.applcation_network.name
  address_prefixes     = ["${var.subnet_allocated}"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_profile" "lab-net-profile" {
  name                = "${var.name}-lab-net-profile"
  location            = "australiaeast"
  resource_group_name = var.resource_group_name

  container_network_interface {
    name = "${var.name}-container-network-int"

    ip_configuration {
      name      = "${var.name}-lab-net-web-ip"
      subnet_id = azurerm_subnet.lab_application_subnet.id
    }
  }
}

resource "azurerm_network_security_group" "lab-2a-security-group" {
  name = "${var.name}-lab-2a-security-group"
  location = "australiaeast"
  resource_group_name = var.resource_group_name

  security_rule {
    name = "HTTP-Service"
    priority = 4011
    direction = "Inbound"
    access = "Deny"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "lab-2a-security-group-association" {
  subnet_id                 = azurerm_subnet.lab_application_subnet.id
  network_security_group_id = azurerm_network_security_group.lab-2a-security-group.id
}

resource "azurerm_container_group" "lab_2a_web_app" {
  name                = "${var.name}-lab-2a-web_app"
  location            = "australiaeast"
  resource_group_name = var.resource_group_name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.lab-net-profile.id
  os_type             = "Linux"

  container {
    name   = "docker-2048"
    image  = "alexwhen/docker-2048"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "lab-2a-web"
  }
}