resource "google_project" "main" {
  name       = "tfe-host-${var.install_id}"
  project_id = "tfe-host-${var.install_id}"

  auto_create_network = false
  billing_account     = var.billing_account
  folder_id           = var.folder_id
}

resource "google_compute_shared_vpc_host_project" "main" {
  project = google_project.main.project_id
}

resource "google_compute_network" "main" {
  name = "tfe-${var.install_id}"

  auto_create_subnetworks = false
  description             = "A shared VPC network to host TFE."
  project                 = google_project.main.project_id
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "main" {
  ip_cidr_range = "10.222.0.0/22"
  name          = "tfe-${var.install_id}"
  network       = google_compute_network.main.self_link

  description = "A subnetwork to host TFE."
  project     = google_project.main.project_id
  region      = var.region
}

resource "google_compute_router" "main" {
  name    = "tfe-${var.install_id}"
  network = google_compute_network.main.self_link

  description = "A router to route TFE traffic."
  region      = var.region
  project     = google_project.main.project_id
}

resource "google_compute_router_nat" "main" {
  name                               = "tfe-${var.install_id}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.main.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  project = google_project.main.project_id
  region  = var.region
}

resource "google_compute_firewall" "health_checks" {
  name    = "tfe-health-check-${var.install_id}"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"
  }
  direction = "INGRESS"
  project   = google_project.main.project_id
  source_ranges = [
    "130.221.0.0/22",
    "209.85.152.0/22",
    "209.85.204.0/22",
    "35.191.0.0/16",
  ]
}

resource "google_compute_firewall" "application" {
  name    = "tfe-application-${var.install_id}"
  network = google_compute_network.main.self_link

  allow {
    protocol = "tcp"

    ports = [
      22,
      80,
      443,
      5432,
      6443,
      6783,
      8800,
      23010,
    ]
  }
  allow {
    protocol = "udp"

    ports = [
      6783,
      6784
    ]
  }
  direction = "INGRESS"
  project   = google_project.main.project_id
  source_ranges = [
    google_compute_subnetwork.main.ip_cidr_range
  ]
}
