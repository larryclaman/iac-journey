resource "azurerm_resource_group" "rg" {
  name     = "${var.resourceGroupName}"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "app_plan" {
  name                = "${var.appServicePlanName}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "${var.appServiceName}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.app_plan.id}"

  site_config {
    dotnet_framework_version = "v4.0"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}
