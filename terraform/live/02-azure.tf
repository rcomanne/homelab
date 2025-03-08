locals {
  location = "West Europe"
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "rg-we-homelab"
}

resource "azurerm_key_vault" "kube_vault" {
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  location                  = local.location
  resource_group_name       = azurerm_resource_group.rg.name
  name                      = "kv-we-rc-homelab"
  sku_name                  = "standard"
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "kube_vault" {
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_resource_group.rg.id
}

resource "azurerm_key_vault_secret" "talosconfig" {
  depends_on = [
    azurerm_role_assignment.kube_vault
  ]

  key_vault_id = azurerm_key_vault.kube_vault.id
  name         = "talosconfig"
  value        = data.talos_client_configuration.this.talos_config
}

resource "azurerm_key_vault_secret" "kubeconfig" {
  depends_on = [
    azurerm_role_assignment.kube_vault
  ]

  key_vault_id = azurerm_key_vault.kube_vault.id
  name         = "kubeconfig"
  value        = talos_cluster_kubeconfig.this.kubeconfig_raw
}