output "address" {
  value = aws_elb.web.dns_name
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}

