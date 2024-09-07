variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "firewall_allowed_ips" {
  type = list(string)
}
