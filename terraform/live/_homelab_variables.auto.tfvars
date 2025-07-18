talos_iso_file                = "local:iso/talos-1_10_5-metal-amd64.iso"
talos_factory_installer_image = "factory.talos.dev/metal-installer/84f66f3fa52900a0234636ae1da07d5b356cce774673951af35866142158fce6:v1.10.5"

k8s_masters = {
  "k8s-master-0" = {
    vmid        = 190
    ip_address  = "192.168.2.190"
    mac_address = "36:19:66:9F:69:AD"
  }
}

k8s_workers = {
  "k8s-worker-0" = {
    vmid        = 191
    ip_address  = "192.168.2.191"
    mac_address = "4E:08:5A:46:47:1A"
  }
  "k8s-worker-1" = {
    vmid        = 192
    ip_address  = "192.168.2.192"
    mac_address = "42:3D:1A:9F:6F:C3"
  }
  "k8s-worker-2" = {
    vmid        = 193
    ip_address  = "192.168.2.193"
    mac_address = "16:62:55:88:F2:32"
  }
}

domain = "rcomanne.nl"

argo_cd_helm_chart_version = "8.1.3"

truenas_host           = "192.168.2.3"
truenas_data_set_iscsi = "habbo/k8s/iscsi"