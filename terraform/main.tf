terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "random" {
    length = 5
    special = "false"
    upper = "false"
}

resource "random_string" "password" {
  count = 3
  length = 16
  special = true
}

resource "azurerm_resource_group" "main" {
  name = "${var.siteName}-${random_string.random.id}-rg"
  location = "eastus"
}

resource "azurerm_app_service_plan" "appservice" {
  name = "${var.siteName}-${random_string.random.id}-plan"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku {
      tier = "Standard"
      size = "S1"
  }
}

resource "azurerm_app_service" "appservice" {
  count = 3
  name = "${var.siteName}-${random_string.random.id}-${count.index}-site"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.appservice.id

  connection_string {
    name = "Database"
    type = "PostgreSQL"
    value = "Server=${azurerm_postgresql_server.postgres[count.index].name};User Id=${azurerm_postgresql_server.postgres[count.index].administrator_login};Password=${azurerm_postgresql_server.postgres[count.index].administrator_login_password}"
  }

  depends_on = [azurerm_app_service_plan.appservice]
}

resource "azurerm_app_service_slot" "appservice" {
  count = 3
  name = "staging"
  app_service_name = azurerm_app_service.appservice[count.index].name
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.appservice.id

  connection_string {
    name = "Database"
    type = "PostgreSQL"
    value = "Server=${azurerm_postgresql_server.postgres[count.index].name};User Id=${azurerm_postgresql_server.postgres[count.index].administrator_login};Password=${azurerm_postgresql_server.postgres[count.index].administrator_login_password}"
  }

  depends_on = [azurerm_app_service_plan.appservice]
}

resource "azurerm_postgresql_server" "postgres" {
  count = 3
  name = "${var.siteName}-${random_string.random.id}-${count.index}-pgsql"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "GP_Gen5_2"

  storage_profile {
      storage_mb = 5120
      backup_retention_days = 7
      geo_redundant_backup = "Disabled"
  }

  administrator_login = "pgsqladmin"
  administrator_login_password = random_string.password[count.index].result
  version = "9.6"
  ssl_enforcement = "Enabled"
}

resource "azurerm_postgresql_firewall_rule" "postgres" {
  count = 3
  name = "${var.siteName}-${random_string.random.id}-${count.index}-fw"
  resource_group_name = azurerm_resource_group.main.name
  server_name = azurerm_postgresql_server.postgres[count.index].name
  start_ip_address = "0.0.0.0"
  end_ip_address = "255.255.255.255"

  depends_on = [azurerm_postgresql_server.postgres]
}

resource "azurerm_postgresql_database" "postgres" {
  count = 3
  name = "${var.siteName}-${random_string.random.id}-${count.index}-db"
  resource_group_name = azurerm_resource_group.main.name
  server_name = azurerm_postgresql_server.postgres[count.index].name
  charset = "UTF8"
  collation = "English_United States.1252"

  depends_on = [azurerm_postgresql_server.postgres]
}