resource "google_dns_managed_zone" "main" {
  dns_name = "${var.install_id}.${var.dns_name}"
  name     = "tfe-${var.install_id}"

  description = "The DNS managed zone in which TFE will be deployed."
  project     = var.project
  visibility  = "public"
}

resource "google_dns_record_set" "main" {
  managed_zone = google_dns_managed_zone.main.name
  name         = "tfe.${google_dns_managed_zone.main.dns_name}"
  rrdatas      = var.rrdatas
  ttl          = 300
  type         = "A"

  project = var.project
}
