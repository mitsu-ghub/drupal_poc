output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.vpc.id  
}

output "private_subnet_id" {
    description = "SUBNET ID'S"
    value = [for subnet in aws_subnet.private_subnets: subnet.id]  
}

output "public_subnet_id" {
    description = "SUBNET ID'S"
    value = [for subnet in aws_subnet.public_subnets: subnet.id]  
}
