variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "eu-central-1"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance."
  default     = "db.t2.micro" # Free tier eligible instance
}

variable "db_identifier" {
  description = "The identifier name."
  default     = "belrefugees-rds-instance"
}

variable "db_username" {
  description = "Username for the RDS database."
  default     = "db_belrefugees_user"
}

variable "db_password" {
  description = "Password for the RDS database."
  default     = "" # Replace with a secure password
  sensitive   = true
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  default     = "db_belrefugees"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes."
  default     = 20 # Free tier allows up to 20 GB
}

variable "aws_access_key_id" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}