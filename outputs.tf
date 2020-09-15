output "bento_instance_ip_addr" {
  value = aws_instance.instance.public_ip
}