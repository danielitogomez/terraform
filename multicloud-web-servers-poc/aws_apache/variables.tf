variable "region" {
  description = "The AWS region to deploy resources into."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet within the VPC."
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  default     = "ami-051f8a213df8bc089" # Use an appropriate AMI for your region
}

variable "ssh_key" {
  default = "~/.ssh/aws.pub"
}
