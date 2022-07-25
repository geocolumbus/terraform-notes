output ssh_connection {
  value = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_eip_association.eip_association.public_ip}"
}

output stop_command {
  value = "aws ec2 stop-instances --instance-ids ${aws_instance.my_server.id}"
}

output start_command {
  value = "aws ec2 start-instances --instance-ids ${aws_instance.my_server.id}"
}

output user_data {
  value = var.user_data
}