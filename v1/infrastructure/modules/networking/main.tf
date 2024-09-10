terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

resource "hcloud_firewall" "default" {
  name = "default-${var.project_name}-firewall"
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = var.allowed_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "any"
    source_ips = var.allowed_ips
  }

  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "any"
    source_ips = var.allowed_ips
  }

  labels = merge(var.labels, {
    module = "networking"
  })
}
