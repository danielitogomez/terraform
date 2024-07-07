output "db_instance_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "db_instance_username" {
  value = var.db_username
}