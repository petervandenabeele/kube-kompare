provider "google" {
   version = "~> 2.5"
   region = "${var.region}"
   project = "${var.project}"
}
