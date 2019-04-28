resource "google_container_cluster" "kubernetes-cluster" {
  name               = "kubernetes-cluster"
  description        = "GKE Kubernetes cluster"
  initial_node_count = 3

  min_master_version = "${var.min_master_version}"
  node_version       = "${var.node_version}"

  enable_legacy_abac = false
  master_auth {
    # If this block is provided and both username and password are empty, basic authentication will be disabled
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata {
      disable-legacy-endpoints = "true"
    }

    disk_type    = "pd-ssd"
    disk_size_gb = 20

    preemptible  = true

    labels {
      role = "node"
      cluster_name = "${var.name}"
    }
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }

    kubernetes_dashboard {
      disabled = true
    }
  }
}

output "master_version" {
  value = "${google_container_cluster.kubernetes-cluster.master_version}"
}

output "node_version" {
  value = "${google_container_cluster.kubernetes-cluster.node_version}"
}
