# 01 Terraform set-up

* Terraform needs a back-end. Can be local or remote. The terraform logs
  may contain secrets, so needs to be kept secret.
  => easiest for now is to use a local back-end and .gitignore the dir

* Some pre-existing GCE context is needed:
  * a project : `kube-kompare`
  * a service user : `terraform@kube-kompare`

  I am not using the approach of
  https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform
  since that requires an organization that can create other projects. I am
  using the approach where a single project is used, that was already created
  manually by the developer. I am using the project name `kube-kompare` here.

  Also the service user that will run the terraform scripts needs to be
  created manually by the developer and appropriate permissions need to be set.

* Creating the project is done by going to the dashboard:
  https://console.cloud.google.com/home/dashboard
  and selecting the drop down with the projects on top and from there
  selecting the option top right "NEW PROJECT".

* Creating the service account is done by going to the Navigation Menu in
  the dashboard (letft top) and going for `IAM Admin` => `Service Accounts`.

  The click `+ CREATE SERVICE ACCOUNT`:
  * Service account name => `terraform`
  * Service Account ID => `terraform@kube-compare.iam.gserviceaccount.com`
  * Service Account Description => "Terraform uses this account to build infrastructure."

  Press CREATE.

  Service Account Permissions:

  Add the Role `Kubernetes Engine Admin` => this is a broad role, but OK for
  these experiments. In production, use more restrictive roles and define
  more restrictive roles for developers that develop on the cluster.

  Also Add the Role `Service Account User` => The role is needed to execute
  work as a Service Account.

  Also Add the Role `Compute Viewer` => The role is needed for terraform
  to avoid the error

```
google_container_cluster.kubernetes-cluster: Error reading instance group manager
returned as an instance group URL:
"googleapi: Error 403: Required 'compute.instanceGroupManagers.get' permission ...
```

  Create a key for this service account: `+ CREATE KEY`, choose the JSON
  format. This will download a key to the file kube-kompare-<key-id>.json.

  Move that file to a safe place on your computer. E.g you could use could
  use code like this to create that directory and move the secret there:

```
  mkdir -p ~/data/private/kube-kompare/gke_01
  mv ~/Downloads/kube-kompare-<partial-key-ID>.json ~/data/private/kube-kompare/gke_01/terraform-key.json
```

* first GCP object to make is a basic GKE cluster:

We need the "google" provider from Google Cloud.

providers.tf becomes:

```
provider "google" {
   version = "~> 2.5"
   region = "${var.region}"
   project = "${var.project}"
}
```

With a variables.tf of e.g.:

```
variable "region" {
  description = "The GCP region"
  default = "europe-west1"
}

variable "project" {
  description = "The GCP project"
  default = "kube-kompare"
}
```

With these settings a `terraform init` can be run.
