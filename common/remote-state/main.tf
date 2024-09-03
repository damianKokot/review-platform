terraform {
  required_providers {
    aws = {
      version = ">= 5.65.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region  = var.region
  alias   = "root_aws"
  profile = var.root_aws_profile_name
}

provider "aws" {
  region = var.region
}

locals {
  default_tags = {
    project_name = var.project_name
    dir          = replace(path.cwd, "/\\/code\\//", "")
    managed_by   = "terraform"
  }
}

module "organization_account" {
  source             = "../modules/organization-account"
  organization_email = var.organization_email

  providers = {
    aws = aws.root_aws
  }

  tags = local.default_tags
}

module "encryption_key" {
  source = "../modules/encryption-key"
  tags   = local.default_tags
}

module "state_bucket" {
  source = "../modules/state-bucket"

  kms_key_arn = module.encryption_key.kms_key_arn
  tags        = local.default_tags
}

module "state_lock" {
  source = "../modules/state-lock"

  kms_key_arn = module.encryption_key.kms_key_arn
  tags        = local.default_tags
}
