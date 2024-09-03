terraform {
  required_providers {
    aws = {
      version = ">= 5.65.0"
      source  = "hashicorp/aws"
    }
  }
}

locals {
  tags = merge(var.tags, {
    Module = basename(path.module)
  })
}

resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

resource "aws_organizations_account" "account" {
  name  = "review-platform"
  email = var.organization_email

  close_on_deletion = true

  tags = local.tags
}
