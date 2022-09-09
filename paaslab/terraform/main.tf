terraform {
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
  required_version = ">= 0.13"

}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "random" {
}

resource "random_string" "password" {
  count   = 3
  length  = 16
  special = true
}

# resource "azurerm_resource_group" "main" {
#   name     = "${var.siteName}-${var.workshop}-rg"
#   location = "eastus"
#   lifecycle {
#     ignore_changes = [tags, ]
#   }
#   tags = {
#     QueuedBy    = var.Queuedby
#     community   = "Infrastructure"
#     Environment = "MTCDemo"
#     Owner       = "MTC Infrastructure Community"
#   }
# }

data "azurerm_resource_group" "main" {
  name = "${var.siteName}-${var.workshop}-rg"
}



resource "azurerm_app_service_plan" "appservice" {
  name                = "${var.siteName}-${var.workshop}-plan"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  sku {
    tier = "Standard"
    size = "S1"
  }
  lifecycle {
    ignore_changes = [tags, ]
  }
}

resource "azurerm_app_service" "appservice" {
  count               = 3
  name                = "${var.siteName}-${var.workshop}-${count.index}-site${var.suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.appservice.id

  connection_string {
    name  = "Database"
    type  = "PostgreSQL"
    value = "Server=${azurerm_postgresql_server.postgres[count.index].name};User Id=${azurerm_postgresql_server.postgres[count.index].administrator_login};Password=${azurerm_postgresql_server.postgres[count.index].administrator_login_password}"
  }

  depends_on = [azurerm_app_service_plan.appservice]
  lifecycle {
    ignore_changes = [tags, ]
  }
}

resource "azurerm_app_service_slot" "appservice" {
  count               = 3
  name                = "staging"
  app_service_name    = azurerm_app_service.appservice[count.index].name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.appservice.id

  connection_string {
    name  = "Database"
    type  = "PostgreSQL"
    value = "Server=${azurerm_postgresql_server.postgres[count.index].name};User Id=${azurerm_postgresql_server.postgres[count.index].administrator_login};Password=${azurerm_postgresql_server.postgres[count.index].administrator_login_password}"
  }
  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
  }

  depends_on = [azurerm_app_service_plan.appservice]
  lifecycle {
    ignore_changes = [tags, ]
  }
}

resource "azurerm_postgresql_server" "postgres" {
  count = 3
  name  = "${var.siteName}-${var.workshop}-${count.index}-pgsql${var.suffix}"
  // location            = data.azurerm_resource_group.main.location
  location            = "EastUS"
  resource_group_name = data.azurerm_resource_group.main.name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false


  administrator_login          = "pgsqladmin"
  administrator_login_password = random_string.password[count.index].result
  version                      = "9.6"
  ssl_enforcement_enabled      = "true"

  lifecycle {
    ignore_changes = [tags, threat_detection_policy]
  }
}

resource "azurerm_postgresql_firewall_rule" "postgres" {
  count               = 3
  name                = "${var.siteName}-${var.workshop}-${count.index}-fw"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.postgres[count.index].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"

  depends_on = [azurerm_postgresql_server.postgres]
}

resource "azurerm_postgresql_database" "postgres" {
  count               = 3
  name                = "${var.siteName}-${var.workshop}-${count.index}-db"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.postgres[count.index].name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  depends_on = [azurerm_postgresql_server.postgres]
}

