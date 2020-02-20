variable "dns_name" {
  description = "The DNS name of the managed zone in which TFE will be deployed."
  type        = string
}

variable "install_id" {
  description = "The install ID to append to the names of resources."
  type        = string
}

variable "project" {
  description = "The ID of the project in which resources will be created."
  type        = string
}

variable "rrdatas" {
  description = "The string data for the records in the DNS A record set."
  type        = list(string)
}
