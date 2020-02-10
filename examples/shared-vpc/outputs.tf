output "application_url" {
  value = "https://${module.dns.fqdn}"
}

output "dashboard_url" {
  value = module.cluster.installer_dashboard_url
}

output "dashboard_password" {
  value = module.configs.console_password
}
