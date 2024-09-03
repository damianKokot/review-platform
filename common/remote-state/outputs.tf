output "state_bucket" {
  value = module.state_bucket.bucket_name
}

output "state_region" {
  value = var.region
}

output "kms_key_id" {
  value = module.encryption_key.kms_key_arn
}

output "dynamodb_table_name" {
  value = module.state_lock.table_name
}
