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

resource "aws_dynamodb_table" "this" {
  name         = "review-platform-tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}
