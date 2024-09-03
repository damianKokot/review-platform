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

resource "aws_s3_bucket" "this" {
  bucket_prefix = "review-platform-tf-state-"
  tags          = local.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}
