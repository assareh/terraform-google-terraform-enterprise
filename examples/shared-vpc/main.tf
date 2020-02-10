resource "random_pet" "main" {
  length    = 2
  separator = "-"
}

module "host" {
  source = "./modules/host"

  billing_account = var.billing_account
  folder_id       = var.folder_id
  install_id      = random_pet.main.id
  region          = var.region
}

module "service" {
  source = "./modules/service"

  billing_account = var.billing_account
  folder_id       = var.folder_id
  host_project    = module.host.project.project_id
  install_id      = random_pet.main.id
}

module "gcs" {
  source = "./../../modules/gcs"

  install_id = random_pet.main.id

  region = var.region
}

module "postgres" {
  source = "./../../modules/postgres"

  install_id  = random_pet.main.id
  network_url = module.host.network.self_link
}

module "service_account" {
  source = "./../../modules/service-account"

  bucket     = module.gcs.bucket_name
  install_id = random_pet.main.id
}

module "external_config" {
  source = "./../../modules/external-config"

  gcs_bucket          = module.gcs.bucket_name
  gcs_credentials     = module.service_account.credentials
  gcs_project         = module.service.project.project_id
  postgresql_address  = module.postgres.address
  postgresql_database = module.postgres.database_name
  postgresql_password = module.postgres.password
  postgresql_user     = module.postgres.user
}

module "common_config" {
  source = "./../../modules/common-config"

  external_name = module.dns.fqdn

  services_config = module.external_config.services_config
}

module "configs" {
  source = "./../../modules/configs"

  cluster_api_endpoint = module.cluster.cluster_api_endpoint
  # Expand module.common_config to avoid a cycle on destroy
  # https://github.com/hashicorp/terraform/issues/21662#issuecomment-503206685
  common-config = {
    application_config = module.common_config.application_config,
    ca_certs           = module.common_config.ca_certs,
  }
  license_file = var.license_file
}

module "cluster" {
  source = "./../../modules/cluster"

  access_fqdn = module.dns.fqdn
  # Expand module.configs to avoid a cycle on destroy
  # https://github.com/hashicorp/terraform/issues/21662#issuecomment-503206685
  cluster-config = {
    primary_cloudinit   = module.configs.primary_cloudinit
    secondary_cloudinit = module.configs.secondary_cloudinit
  }
  install_id   = random_pet.main.id
  license_file = var.license_file
  project      = module.service.project.project_id
  subnet       = module.host.subnetwork

  gcs_bucket          = module.gcs.bucket_name
  gcs_credentials     = module.service_account.credentials
  gcs_project         = module.service.project.project_id
  postgresql_address  = module.postgres.address
  postgresql_database = module.postgres.database_name
  postgresql_password = module.postgres.password
  postgresql_user     = module.postgres.user
  region              = var.region
}

module "dns_primaries" {
  source = "./../../modules/dns-primaries"

  dnszone    = var.dns_zone
  install_id = random_pet.main.id
  primaries  = module.cluster.primary_external_addresses
  project    = module.service.project.project_id
}

module "cert" {
  source = "./../../modules/cert"

  domain_name = module.dns.fqdn
  install_id  = random_pet.main.id
}

module "lb" {
  source = "./../../modules/lb"

  cert           = module.cert.certificate
  install_id     = random_pet.main.id
  instance_group = module.cluster.application_endpoints
}

module "dns" {
  source = "./../../modules/dns"

  address    = module.lb.address
  dnszone    = var.dns_zone
  hostname   = "tfe"
  install_id = random_pet.main.id
  project    = module.service.project.project_id
}
