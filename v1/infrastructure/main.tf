terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }

  backend "s3" {}
}

provider "hcloud" {
  token = var.hcloud_token
}

locals {
  default_labels = {
    project_name = var.project_name
    managed_by   = "terraform"
    version      = "v1"
  }
}

data "tls_public_key" "default" {
  private_key_openssh = file("~/.ssh/id_rsa")
}

resource "hcloud_ssh_key" "default" {
  name       = "${var.project_name}-default"
  public_key = data.tls_public_key.default.public_key_openssh
  labels     = local.default_labels
}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  allowed_ips  = var.firewall_allowed_ips

  labels = local.default_labels
}
