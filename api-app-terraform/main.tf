
##data "template_file" "init" {
##  template = file(var.install_setup)
##}

##resource "aws_key_pair" "java-app" {
##  key_name   = "java-app"
##  public_key = file(var.ssh_key)
##}

resource "aws_instance" "java-app" {
  ami                         = var.ami
  instance_type               = var.instance_type
#  key_name                    = aws_key_pair.java-app.key_name
  vpc_security_group_ids      = [aws_security_group.sg_allow_tf-ec2.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
#  user_data                   = file(var.install_setup)
  associate_public_ip_address = true
  tags = {
    Name = "java-app"
  }
}

resource "aws_security_group" "sg_allow_tf-ec2" {
  name        = "allow_tf-ec2"
  description = "Allow SSH and java-app inbound traffic"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "java-app-sg"
  }
}
