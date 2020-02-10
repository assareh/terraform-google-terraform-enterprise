resource "google_project" "main" {
  name       = "tfe-service-${var.install_id}"
  project_id = "tfe-service-${var.install_id}"

  auto_create_network = false
  billing_account     = var.billing_account
  folder_id           = var.folder_id
}

resource "google_compute_shared_vpc_service_project" "main" {
  host_project    = var.host_project
  service_project = google_project.main.project_id
}
