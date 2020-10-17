#-------OUTPUTS ------------

output "Database Name" {
  value = "${var.dbname}"
}

output "Database Hostname" {
  value = "${aws_db_instance.db.endpoint}"
}

output "Database Username" {
  value = "${var.dbuser}"
}

output "Database Password" {
  value = "${random_string.postgres_password.result}" 
  sensitive   = true
}
