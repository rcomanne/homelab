resource "proxmox_vm_qemu" "k8s_master_nodes" {
  for_each = var.k8s_masters

  target_node = "pve"
  name        = each.key
  iso         = var.talos_iso_file

  cpu    = "host"
  cores  = each.value.cpu_cores
  memory = each.value.memory

  onboot   = true
  oncreate = true
  agent    = 1

  disk {
    type    = "sata"
    storage = each.value.storage_name
    size    = each.value.storage_size
    format  = "qcow2"
  }

  network {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
    macaddr  = each.value.mac_address
  }

  lifecycle {
    ignore_changes = [
      qemu_os
    ]
  }
}

resource "proxmox_vm_qemu" "k8s_worker_nodes" {
  for_each = var.k8s_workers

  target_node = "pve"
  name        = each.key
  iso         = var.talos_iso_file

  cpu    = "host"
  cores  = each.value.cpu_cores
  memory = each.value.memory

  onboot   = true
  oncreate = true
  agent    = 1
  #  boot     = "order=scsi0;net0"

  disk {
    type    = "sata"
    storage = each.value.storage_name
    size    = each.value.storage_size
    format  = "qcow2"
  }

  network {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
    macaddr  = each.value.mac_address
  }

  lifecycle {
    ignore_changes = [
      qemu_os
    ]
  }
}