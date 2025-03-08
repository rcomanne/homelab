terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3, < 4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4, < 5"
    }

    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.9.14, < 3"
    }

    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.7.1, < 1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2, < 3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2, < 3"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">= 7, < 8"
    }
    # argocd = {
    #   source = "oboukili/argocd"
    #   version = ">= 6, < 7"
    # }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.25, < 2"
    }
  }

  backend "remote" {
    organization = "rcomanne"

    workspaces {
      name = "homelab"
    }
  }
}