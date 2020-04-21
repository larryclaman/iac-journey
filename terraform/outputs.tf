output "db_password1" {
    value = azurerm_postgresql_server.postgres[0].administrator_login_password
    description = "The password for logging into the database"
}

output "db_password2" {
    value = azurerm_postgresql_server.postgres[1].administrator_login_password
    description = "The password for logging into the database"
}

output "db_password3" {
    value = azurerm_postgresql_server.postgres[2].administrator_login_password
    description = "The password for logging into the database"
}