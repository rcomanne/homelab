resource "kubernetes_namespace" "csi" {
  metadata {
    name = "csi"
    labels = {
      "app.kubernetes.io/managed-by"       = "terraform"
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
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
      truenasApiKey             = var.truenasApiKey,
      truenasHost               = var.truenasHost
      truenasPort               = var.truenasPort
      datasetParentName         = "${var.truenasDataSetIscsi}/v"
      snapshotDatasetParentName = "${var.truenasDataSetIscsi}/s"
    })
  }
}