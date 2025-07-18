talos_iso_file = "local:iso/talos-1_10_5-metal-amd64.iso"

k8s_masters = {
  "k8s-master-0" = {
    ip_address  = "192.168.2.190"
    mac_address = "36:19:66:9F:69:AD"
  }
}

k8s_workers = {
  "k8s-worker-0" = {
    ip_address  = "192.168.2.191"
    mac_address = "4E:08:5A:46:47:1A"
  }
  "k8s-worker-1" = {
    ip_address  = "192.168.2.192"
    mac_address = "42:3D:1A:9F:6F:C3"
  }
  "k8s-worker-2" = {
    ip_address  = "192.168.2.193"
    mac_address = "16:62:55:88:F2:32"
  }
}

domain = "rcomanne.nl"

argo_cd_helm_chart_version = "8.1.3"

truenas_host           = "192.168.2.3"
truenas_data_set_iscsi = "habbo/k8s/iscsi"