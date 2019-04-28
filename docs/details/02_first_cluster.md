# 02 First cluster

Adding a basic template for a `google_container_cluster`
(that is the old name for the kubernetes cluster, still in
use in terraform for this resource type), yields the obvious error:

```
* google_container_cluster.kubernetes-cluster: googleapi: Error 403: Required "container.clusters.create" permission(s) for "projects/kube-kompare". See https://cloud.google.com/kubernetes-engine/docs/troubleshooting#gke_service_account_deleted for more info., forbidden
```

We need to use the terraform-key.json key to authenticate first ...

Possible code for this is below. It will set
`GOOGLE_APPLICATION_CREDENTIALS` to the location of terraform-key.json.

Ref. https://www.terraform.io/docs/providers/google/provider_reference.html
for full details.

```
export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/data/private/kube-kompare/gke_01/terraform-key.json"
```

The container can now be created with:

```
terraform init
terraform plan
terraform apply
```

The first time this is tried, GCP will complain that the Kubernetes Engine API
is never been used. So it must be activated (e.g. through the console):

```
* google_container_cluster.kubernetes-cluster: googleapi: Error 403: Kubernetes Engine API has not been used in project <Project Number> before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=<Project Number> then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry., accessNotConfigured
```
and press "ENABLE".

Once the API is enabled, a first cluster can be built with:

```
terraform plan
terraform apply
```

After the first experiment, the cluster can be destroyed with

```
terraform destroy
```

Or, more reliably ... move the `kubernetes-cluster.tf` file to a subdirectory,
e.g. INACTIVE. In that case, a new terraform apply will destroy the cluster
(and the `terraform apply` operation is uniform and idempotent).
