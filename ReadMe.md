# Homelab
This repository creates a k8s based homelab, rolled out on Proxmox.

## Requirements

You need:
- Proxmox cluster
- Proxmox API user
- Talos ISO loaded into Proxmox
- Azure subscription (free is fine, only storing some credentials)
- IP reservations

### Proxmox
Have a [Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) running.  
It's wise to read through the [Talos docs for installing on Proxmox](https://www.talos.dev/v1.9/talos-guides/install/virtualized-platforms/proxmox/) to get an idea of what happens.  

You'll need to add a specific ISO from the Talos factory which includes the QEMU guest agent for optimal workings.  

You'll also need a user for Proxmox, for this read the [proxmox provider docs](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs).

### IP reservations
I create static leases in my DHCP server based on pre generated MAC addresses, you can generate these addresses by running a `tf apply` from `terraform/macaddress`