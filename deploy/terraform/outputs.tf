output "address" {
  value = aws_lb.lb.dns_name
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}

