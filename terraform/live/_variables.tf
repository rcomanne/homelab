variable "pm_api_token_id" {
  type      = string
  sensitive = true
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "azure_subscription_id" {
  type = string
}

variable "k8s_masters" {
  type = map(object({
    mac_address  = string
    ip_address   = string
    cpu_cores    = optional(number, 2)
    memory       = optional(number, 4096)
    storage_size = optional(string, "32G")
    storage_name = optional(string, "bx100")
  }))
}

variable "k8s_workers" {
  type = map(object({
    mac_address  = string
    ip_address   = string
    cpu_cores    = optional(number, 4)
    memory       = optional(number, 8192)
    storage_size = optional(string, "64G")
    storage_name = optional(string, "bx100")
  }))
}

variable "talos_iso_file" {
  type = string
}

variable "domain" {
  type = string
}

variable "argo_cd_helm_chart_version" {
  type = string
}

variable "truenas_host" {
  type = string
}

variable "truenas_port" {
  type    = number
  default = 80
}

variable "truenas_api_key" {
  type      = string
  sensitive = true
}

variable "truenas_data_set_iscsi" {
  type = string
}