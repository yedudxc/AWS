
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

