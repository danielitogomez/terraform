variable "region" {
  default = "eu-central-1"
}

variable "environment" {
  default = "Development"
}

variable "ami" {
  default = "ami-076309742d466ad69"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
}

variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 cidr block"
  default = ""
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 cidr block"
  default = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ssh_key" {
  default = "/home/danijarvis/.ssh/id_rsa_ec2_key.pub"
}

variable "install_setup" {
  default = "/home/danijarvis/github/api-model-template-infra/terraform/scripts/install-setup.sh"
}