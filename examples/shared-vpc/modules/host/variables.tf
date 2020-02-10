variable "billing_account" {
  description = "The ID of the billing account to which the project will belong."
  type        = string
}

variable "folder_id" {
  description = "The ID of the folder under which the project will be created."
  type        = string
}

variable "install_id" {
  description = "The install ID to append to the names of resources."
  type        = string
}

variable "region" {
  description = "The region in which resources will be created."
  type        = string
}
