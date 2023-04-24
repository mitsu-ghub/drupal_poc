output "Bastion_public_ip" {
    description = "Public IP of Bastion Server"
    value = aws_instance.bastion.public_ip
  
}

output "Bastion_public_dns" {
    description = "Public DNS of Bastion Server"
    value = aws_instance.bastion.public_dns
  
}