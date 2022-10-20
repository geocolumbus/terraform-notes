terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

resource "aws_security_group" "basic_security_group" {
  name        = "basic_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = format("%s-sg", var.server_name)
    Owner = var.owner
  }
}

resource "aws_instance" "basic_cloud_server" {
  ami = var.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.basic_security_group.id]
  key_name = var.key_name
  subnet_id = var.subnet_id
  user_data = file("${path.module}/user_data.sh")
  tags = {
    Name = var.server_name
    Owner = var.owner
  }
}

resource "aws_eip_association" "eip_association" {
  allocation_id = var.elastic_ip_address
  instance_id = aws_instance.basic_cloud_server.id
}
