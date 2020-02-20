output "fqdn" {
  value = trimsuffix(google_dns_record_set.main.name, ".")

  description = "The fully qualified domain name of the TFE deployment."
}

output "dns_managed_zone" {
  value = google_dns_managed_zone.main

  description = "The DNS managed zone."
}
