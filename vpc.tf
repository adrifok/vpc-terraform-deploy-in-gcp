# create VPC
# Refernce: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network.html
# Reference: https://github.com/terraform-google-modules/terraform-google-network/blob/v7.1.0/modules/vpc/main.tf
resource "google_compute_network" "gke_vpc" {
  name                    = "${local.name}-${var.vpc_name}"
  routing_mode            = var.routing_mode
  mtu                     = var.mtu
  auto_create_subnetworks = var.auto_create_subnetworks
}



# Create subnetwork
# reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork.html
# reference: https://github.com/terraform-google-modules/terraform-google-network/blob/v7.1.0/modules/subnets/main.tf
resource "google_compute_subnetwork" "subnetwork" {
  name          = "${local.name}-subnet"
  region        = var.region
  network       = google_compute_network.gke_vpc.name
  ip_cidr_range = var.ip_cidr_range
  secondary_ip_range {
    range_name    = var.pod_range_name
    ip_cidr_range = var.pod_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = var.service_range_name
    ip_cidr_range = var.service_ip_cidr_range
  }
  log_config {
    aggregation_interval = var.vpc_log_config_aggregation_interval
    flow_sampling        = var.vpc_log_config_flow_sampling
    metadata             = var.vpc_log_config_metadata
  }
}



resource "google_compute_subnetwork" "private_subnetwork" {
  name          = "${local.name}-private-subnet"
  region        = var.region
  network       = google_compute_network.gke_vpc.name
  ip_cidr_range = var.private_ip_cidr_range
  log_config {
    aggregation_interval = var.vpc_log_config_aggregation_interval
    flow_sampling        = var.vpc_log_config_flow_sampling
    metadata             = var.vpc_log_config_metadata
  }
}
