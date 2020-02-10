output "network" {
  value = google_compute_network.main

  description = "The shared VPC network."
}

output "project" {
  value = google_project.main

  description = "The shared VPC host project."
}

output "subnetwork" {
  value = google_compute_subnetwork.main

  description = "The shared VPC subnetwork."
}
