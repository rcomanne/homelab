locals {
  argo_cd_namespace      = "argo"
  argo_cd_host           = "argocd.${var.domain}"
  argo_cd_admins         = [data.azuread_client_config.current.object_id]
  argo_cd_repository     = "https://argoproj.github.io/argo-helm"
  argo_cd_cluster_server = "https://kubernetes.default.svc"
}

resource "time_rotating" "argo_cd" {
  rotation_months = 2
}

resource "random_password" "argo_cd_admin" {
  length  = 32
  special = false

  lifecycle {
    replace_triggered_by = [
      time_rotating.argo_cd.id
    ]
  }
}

resource "azurerm_key_vault_secret" "argo_cd_admin" {
  key_vault_id = azurerm_key_vault.kube_vault.id
  name         = "argo-cd-admin"
  value        = random_password.argo_cd_admin.result
}

resource "azuread_application" "argo_cd" {
  display_name = "homelab-argo-cd"
  owners = [
    data.azuread_client_config.current.object_id
  ]

  web {
    redirect_uris = [
      "http://localhost:8085/auth/callback",
      "https://${local.argo_cd_host}/auth/callback",
    ]
  }

  optional_claims {
    access_token {
      name      = "groups"
      essential = true
    }
    id_token {
      name      = "groups"
      essential = true
    }
  }

  group_membership_claims = ["SecurityGroup"]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    // User.Read
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "argo_cd" {
  client_id = azuread_application.argo_cd.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "argo_cd" {
  service_principal_id = azuread_service_principal.argo_cd.id
  rotate_when_changed = {
    rotate = time_rotating.argo_cd.id
  }
}

resource "azurerm_key_vault_secret" "argo_cd_spn" {
  key_vault_id = azurerm_key_vault.kube_vault.id
  name         = "argo-cd-spn"
  value        = azuread_service_principal_password.argo_cd.value
}

resource "azuread_group" "argo_cd_admin" {
  display_name     = "argocd-admin"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = local.argo_cd_admins
}

resource "helm_release" "argo_cd" {
  repository = local.argo_cd_repository
  chart      = "argo-cd"

  namespace        = "argo"
  create_namespace = true
  name             = "argo-cd"
  version          = var.argo_cd_version

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = random_password.argo_cd_admin.bcrypt_hash
  }

  set_sensitive {
    name  = "configs.secret.extra.oidc\\.azure\\.clientSecret"
    value = azuread_service_principal_password.argo_cd.value
  }

  values = [
    templatefile("${path.module}/helm-values/argo-cd.yaml", {
      argo_cd_host        = local.argo_cd_host,
      directory_tenant_id = data.azuread_client_config.current.tenant_id
      oidc_client_id      = azuread_application.argo_cd.client_id
      oidc_admin_group_id = azuread_group.argo_cd_admin.object_id
    })
  ]

  cleanup_on_fail = true
  wait            = true
}

resource "argocd_repository" "homelab" {
  repo = local.repo_url
}

