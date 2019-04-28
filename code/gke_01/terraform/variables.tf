variable "project" {
  description = "The GCP project"
  default = "kube-kompare"
}

variable "region" {
  description = "The GCP region"
  default = "europe-west1"
}

variable "zone" {
  description = "The GCP zone"
  default = "europe-west1-c"
}

variable "node_version" {
  description = "Node version; this evolves fast ! An upgrade of the node version here, triggers a new cluster?"
  default = "1.12.7-gke.10"
}

variable "min_master_version" {
  description = "Minimal master version; this evolves fast !"
  default = "1.12.7"
}

variable "name" {
  description = "Name of the kubernetes cluster; can be re-uses quickly after deletion."
  default = "kubernetes-cluster"
}
