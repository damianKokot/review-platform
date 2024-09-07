variable "project_name" {
  type = string
}

variable "allowed_ips" {
  type = list(string)
}

variable "labels" {
  type    = map(string)
  default = {}
}
