resource "argocd_project" "apps" {
  metadata {
    name      = "apps"
    namespace = helm_release.argo_cd.namespace
  }

  spec {
    description  = "This project contains all applications running on the cluster."
    source_repos = ["*"]

    destination {
      server    = local.argo_cd_cluster_server
      namespace = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_application_set" "apps" {
  metadata {
    name      = "homelab-apps"
    namespace = helm_release.argo_cd.namespace
  }

  spec {
    go_template         = true
    go_template_options = ["missingkey=error"]

    generator {
      git {
        repo_url = local.repo_url
        revision = "HEAD"

        directory {
          path = "deployments/apps/*/*"
        }
      }
    }

    template {
      metadata {
        name      = "{{.path.basenameNormalized}}"
        namespace = local.argo_cd_namespace
      }

      spec {
        project = argocd_project.apps.metadata[0].name
        source {
          repo_url        = local.repo_url
          target_revision = "HEAD"
          path            = "{{.path.path}}"
        }

        destination {
          server    = local.argo_cd_cluster_server
          namespace = "{{index .path.segments 2}}"
        }

        sync_policy {
          automated {
            prune       = true
            self_heal   = true
            allow_empty = true
          }
          sync_options = [
            "CreateNamespace=true"
          ]
        }
      }
    }
  }
}