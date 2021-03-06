
/*
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
*/
output "ResourceGroupName" {
  value       = "${var.siteName}-${var.workshop}-rg"
  description = "Resource Group used in deployment"
}

output "AppServiceName" {
  value       = "${var.siteName}-${var.workshop}"
  description = "Prefix to app service name.  Needs [0,1,2]-site appended to it."
}