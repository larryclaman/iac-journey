provider "azurerm" {
  subscription_id = "${var.subscriptionId}"
  tenant_id       = "${var.tenantId}"
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
}
