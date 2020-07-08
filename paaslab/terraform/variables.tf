/*
variable "environment" {
  description = "The name of the environment"
}
*/

variable "siteName" {
  default = "tailspintoys"
  description = "The name of the site"
}

variable "workshop" {
  default = "paaslab"
  description = "type of workshop"
}

variable "Queuedby" {
  description = "Who ran the deployment job?"
  default     = "Azure DevOps"
}
