variable "aws_access_key" {
  description = "The access key for the account"
  type = string
}

variable "aws_secret_key" {
  description = "The secret key for the account"
  type = string
}

variable "aws_region" {
  description = "The region to use for the tests"
  type = string
  default = "us-east-2"
}

variable "elastic_ip_address" {
  description = "The elastic IP address"
  type = string
  default = "eipalloc-0643fd08d5414ac1c"
}

variable "ami" {
  description = "The AMI to use"
  type = string
  default = "ami-02d1e544b84bf7502"
}

variable "key_name" {
  description = "The key pair to use"
  type = string
  default = "OHIOKEYS2021"
}

variable "server_name" {
  description = "The name of the server"
  type = string
  default = "cloud1"
}

variable "owner" {
  description = "The owner of the server"
  type = string
  default = "georgecampbell"
}

variable "user_data" {
    description = "The user data to apply to the server"
    type = string
    default = <<EOF
#!/bin/bash

# Install useful tools
sudo yum upgrade -y
sudo yum install -y tree vim git wget htop

# Install aws cli v2
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
sudo ./aws/install
rm -rf aws awscli-exe-linux-x86_64.zip

# Install ATOP and SAR
sudo amazon-linux-extras install epel -y
sudo yum install sysstat atop --enablerepo=epel -y
sudo sed -i 's/^INTERVAL=600.*/INTERVAL=60/' /etc/sysconfig/atop
sudo sed -i -e 's|*/10|*/1|' -e 's|every 10 minutes|every 1 minute|' /etc/cron.d/sysstat
EOF
}
