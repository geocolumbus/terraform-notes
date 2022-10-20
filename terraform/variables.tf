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