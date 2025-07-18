resource "kubernetes_namespace" "csi" {
  metadata {
    name = "csi"
    labels = {
      "app.kubernetes.io/managed-by"       = "terraform"
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }

  depends_on = [
    data.talos_cluster_health.this
  ]
}

resource "kubernetes_secret" "democratic_csi_driver" {
  metadata {
    name      = "democratic-csi-driver-config"
    namespace = kubernetes_namespace.csi.metadata[0].name

    labels = {
      "app.kubernetes.io/name"       = "deomcratic-csi"
      "app.kubernetes.io/instance"   = "democratic-csi-iscsi"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    "driver-config-file.yaml" = templatefile("${path.module}/templates/democratic-csi-iscsi-config-file.yaml", {
      truenasApiKey             = var.truenas_api_key,
      truenasHost               = var.truenas_host
      truenasPort               = var.truenas_port
      datasetParentName         = "${var.truenas_data_set_iscsi}/v"
      snapshotDatasetParentName = "${var.truenas_data_set_iscsi}/s"
    })
  }

  depends_on = [
    data.talos_cluster_health.this
  ]
}