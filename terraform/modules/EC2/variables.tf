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
  default = "basic-cloud-server"
}

variable "owner" {
  description = "The owner of the server"
  type = string
  default = "georgecampbell"
}

variable "vpc_id" {
  description = "The VPC ID"
  type = string
  default = "vpc-94c636fd"
}

variable "subnet_id" {
  description = "Default subnet us-east-2c"
  type = string
  default = "subnet-f73b0bbd"
}
