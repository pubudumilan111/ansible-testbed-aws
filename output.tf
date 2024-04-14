output "master_public_ip" {
  value = aws_instance.ansible_master.public_ip
}

output "host_private_ip" {
  value = aws_instance.ansible_host.private_ip
}