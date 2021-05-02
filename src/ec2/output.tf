output "instance_public_dns" {
  value = aws_instance.default_instance.public_dns
}

output "instance_public_ip" {
  value = aws_instance.default_instance.public_ip
}

output "instance_private_ip" {
  value = aws_instance.default_instance.private_ip
}
