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

data "hcloud_datacenters" "this" {}

locals {
  region_name = "fsn1"
  datacenters = data.hcloud_datacenters.this.datacenters
  datacenter_name = local.datacenters[
    index(local.datacenters.*.location.name, local.region_name)
  ].name
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

resource "hcloud_server" "master" {
  name        = "master"
  image       = "ubuntu-24.04"
  server_type = "cx32"
  datacenter  = local.datacenter_name
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  firewall_ids = [module.networking.firewall_id]

  labels = merge(local.default_labels, {
    module = "main"
  })
}

resource "local_file" "ansible_inventory" {
    content  = <<-EOT
      all:
        hosts:
          master:
            ansible_host: ${hcloud_server.master.ipv4_address}
    EOT
    filename = "${path.module}/../configuration/inventory.yaml"
}
