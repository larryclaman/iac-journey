variable "appServiceName" {
  type        = "string"
  description = "The name of app service"
}

variable "appServicePlanName" {
  type        = "string"
  description = "The name of app service plan"
}

variable "resourceGroupName" {
  type        = "string"
  description = "The name of resource group"
}

variable "location" {
  type        = "string"
  description = "Location"
}

variable "subscriptionId" {
  type        = "string"
  description = "Subscription id"
}

variable "tenantId" {
  type        = "string"
  description = "Tenant id"
}

variable "clientId" {
  type        = "string"
  description = "Client id"
}

variable "clientSecret" {
  type        = "string"
  description = "Client secret"
}
