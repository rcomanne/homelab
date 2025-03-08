output "talosconfig" {
  value     = data.talos_client_configuration.this.client_configuration
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}