locals {
  master_ips       = [for master in var.k8s_masters : master.ip_address]
  worker_ips       = [for worker in var.k8s_workers : worker.ip_address]
  cluster_name     = "talos-homelab"
  cluster_endpoint = "https://${local.master_ips[0]}:6443"
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = local.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = local.master_ips
}

resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [
    proxmox_vm_qemu.k8s_master_nodes
  ]

  for_each = var.k8s_masters

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = each.value.ip_address
  config_patches = [
    templatefile("${path.module}/templates/talos-node-configuration.yaml", {
      hostname                       = each.key
      talos_factory_installer_imager = var.talos_factory_installer_image
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [
    proxmox_vm_qemu.k8s_worker_nodes
  ]

  for_each = var.k8s_workers

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value.ip_address
  config_patches = [
    templatefile("${path.module}/templates/talos-node-configuration.yaml", {
      hostname                       = each.key
      talos_factory_installer_imager = var.talos_factory_installer_image
    })
  ]
}

resource "talos_machine_bootstrap" "controlplane" {
  depends_on = [
    talos_machine_configuration_apply.controlplane
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.master_ips[0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.controlplane
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.master_ips[0]
}

data "talos_client_configuration" "full" {
  client_configuration = talos_machine_secrets.this.client_configuration
  cluster_name         = local.cluster_name

  endpoints = local.master_ips
  nodes = concat(
    local.master_ips,
    local.worker_ips
  )
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.controlplane,
    talos_machine_configuration_apply.worker,
    talos_cluster_kubeconfig.this
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.master_ips
  control_plane_nodes  = local.master_ips
  worker_nodes         = local.worker_ips
}