output "public_instance_dns" {
  value = aws_instance.default_instance.public_dns
}

output "public_instance_ip" {
    value = aws_instance.default_instance.public_ip
}
