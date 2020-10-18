output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}
output "database_name" {
  value = var.dbname
}

output "database_hostname" {
  value = aws_db_instance.db.endpoint
}

output "database_username" {
  value = var.dbuser
}

output "database_password" {
  value = random_string.postgres_password.result 
  sensitive   = true
}
