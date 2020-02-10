variable "billing_account" {
  description = "The ID of the billing account to which the project will belong."
  type        = string
}

variable "dns_zone" {
  description = "The name of the managed DNS zone in which records will be created."
  type        = string
}

variable "folder_id" {
  description = "The ID of the folder under which projects will be created."
  type        = string
}

variable "license_file" {
  description = "The pathname of a TFE Replicated license file."
  type        = string
}

variable "region" {
  default     = "us-central1"
  description = "The region in which resources will be created."
  type        = string
}

# variable "org_id" {
#   description = "The ID of the organization in which resources will be created."
#   type        = string
# }
