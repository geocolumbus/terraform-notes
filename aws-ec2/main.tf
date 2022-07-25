terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

resource "aws_instance" "my_server" {
  ami = var.ami
  associate_public_ip_address = false
  instance_type = "t3.small"
  security_groups = [
    "cloud-security-group"]
  key_name = var.key_name
  user_data = var.user_data
  tags = {
    Name = var.server_name
    Owner = var.owner
  }
}

resource "aws_eip_association" "eip_association" {
  allocation_id = var.elastic_ip_address
  instance_id = aws_instance.my_server.id
}
