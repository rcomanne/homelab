talos_iso_file = "local:iso/talos-1_9_4-metal-amd64.iso"

k8s_masters = {
  "k8s-master-0" = {
    ip_address  = "192.168.2.168"
    mac_address = "F2:47:8D:95:5E:39"
  }
}

k8s_workers = {
  "k8s-worker-0" = {
    ip_address  = "192.168.2.174"
    mac_address = "0A:CA:3E:20:EE:4E"
  }
  "k8s-worker-1" = {
    ip_address  = "192.168.2.175"
    mac_address = "B6:52:BA:6F:D3:E0"
  }
  "k8s-worker-2" = {
    ip_address  = "192.168.2.176"
    mac_address = "86:15:85:2F:32:C7"
  }
}

domain = "rcomanne.nl"

argo_cd_version = "7.8.8"

truenasHost         = "192.168.2.3"
truenasDataSetIscsi = "/habbo/k8s/iscsi"