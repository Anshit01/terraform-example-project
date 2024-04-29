terraform {
  backend "gcs" {
    bucket  = "tf-bucket-817906"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}

module "instances" {
  source = "./modules/instances"
}

module "storage" {
    source = "./modules/storage"
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
#   version      = "6.0.0"
  project_id   = var.project_id
  network_name = "tf-vpc-720668"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-east1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-east1"
    }
  ]
}

resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = "tf-vpc-720668"

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_network" "default" {
  name = "test-network"
}
