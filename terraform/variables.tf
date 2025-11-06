variable "prefix" {
  default = "epkbk"
}
variable "region" {
  default = "ap-southeast-1"
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "db_admin" {}
variable "db_admin_password" {}
