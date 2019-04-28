provider "google" {
   version = "~> 2.5"
   project = "${var.project}"
   region = "${var.region}"
   zone = "${var.zone}"
}
