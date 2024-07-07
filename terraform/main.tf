

data "template_file" "init" {
  template = file(var.install_setup)
}

resource "aws_key_pair" "tf-ec2" {
  key_name   = "tf-ec2"
  public_key = file(var.ssh_key)
}

resource "aws_instance" "tf-ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.tf-ec2.key_name
  vpc_security_group_ids      = [aws_security_group.sg_allow_tf-ec2.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
  user_data                   = file(var.install_setup)
  associate_public_ip_address = true
  tags = {
    Name = "tf-ec2"
  }
}

resource "aws_security_group" "sg_allow_tf-ec2" {
  name        = "allow_tf-ec2"
  description = "Allow SSH and tf-ec2 inbound traffic"
  vpc_id      = aws_vpc.development-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-ec2-sg"
  }
}
