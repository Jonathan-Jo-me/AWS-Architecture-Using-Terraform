output "private_server_1_id" {
  value = aws_instance.private_server_1.id
}

output "private_server_2_id" {
  value = aws_instance.private_server_2.id
}

output "private_server_sg_id" {
  value = aws_security_group.private_server_sg.id
}
