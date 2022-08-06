# AWS EC2 Instance Terraform Script

## Usage

You need to place the AWS keys into environment variables that Terraform can access, like this:
```bash
export TF_VAR_aws_access_key=LKWA...
export TF_VAR_aws_secret_key=nPuh...
export TF_VAR_aws_region=us-east-2
```

Now you can run the scripts:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## TODO

* Create meta configuration file
* Link to a DNS address
  * VPC
  * Load Balancer
  * HTTPS
* Create default web app
* Get initialization script from GIT

## Server Control

```bash
$ ssh -i ~/.ssh/OHIOKEYS2021.pem ec2-user@3.133.23.163
$ aws ec2 start-instances --instance-ids i-05e3141d23453a698
$ aws ec2 stop-instances --instance-ids i-05e3141d23453a698
```
