variable "app_name" {}
variable "internal_networks" {
    type = list(string)
    default = ["10.0.0.0/16"]
}
variable "subnet_id" {}
variable "bounded_context" {}
variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+MPbSoDnncbAAFGw0aammN5bimYrQ1533jyiYr3fTa8aN7U1CEbKBdnK1KUSubEVMtTyVGqcJ5EWoZo0sNkdFcjauhtuoojD7J6TKq6ML/YzUbNpTZo0l4Zq/N2PG/jM3Nyj4y6j2YKAkQK6FSofwY41Z+uiifTEcico2mSRuqwxSucEPGVZZ4x0mR2CbNnV5oTEF+KTktqVx+pw8d3wMtQWAu4f/HgeoQudXLNsyjzhb57JxpXKDVj+tNVKt5W9xBdSZqe2wb7f5xSay95sIJXZK6xUhUaVe57kxR2QiXUfapAIG4B2nheHdaFhINDrq01s8JZCCoTFzOHMXuEId centos@moodle.pnt.edu.vn"
}