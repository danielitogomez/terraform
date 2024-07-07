provider "aws" {
  region     = var.region
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "multicloud_poc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "multicloud_poc"
  }
}

resource "aws_subnet" "multicloud_poc" {
  vpc_id                  = aws_vpc.multicloud_poc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "multicloud_poc"
  }
}

resource "aws_internet_gateway" "multicloud_poc" {
  vpc_id = aws_vpc.multicloud_poc.id
}

resource "aws_route_table" "multicloud_poc" {
  vpc_id = aws_vpc.multicloud_poc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.multicloud_poc.id
  }
}

resource "aws_route_table_association" "multicloud_poc" {
  subnet_id      = aws_subnet.multicloud_poc.id
  route_table_id = aws_route_table.multicloud_poc.id
}

resource "aws_security_group" "multicloud_poc" {
  name        = "ssh_http_sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.multicloud_poc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "multicloud_poc" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.multicloud_poc.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.multicloud_poc.key_name
  vpc_security_group_ids      = [aws_security_group.multicloud_poc.id]

  user_data = <<-EOF
                #!/bin/bash
                exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
                echo "Starting the update and installation process..."
                sudo yum update -y
                echo "Installing HTTPD (Apache)..."
                sudo yum install httpd -y
                echo "Starting HTTPD service..."
                sudo systemctl start httpd
                echo "Enabling HTTPD on boot..."
                sudo systemctl enable httpd
                EOF

  tags = {
    Name = "multicloud_poc"
  }
}

resource "aws_key_pair" "multicloud_poc" {
  key_name   = "multicloud_poc_key"
  public_key = file(var.ssh_key)
}