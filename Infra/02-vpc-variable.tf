
variable "vpc_Cidr" {
    description = "VPC CIDR block range"
    type = string
    default = "10.0.0.0/16"
  
}

variable "subnet_name" {
    description = "Subnet Name"
    type = map(string)
    default = {
        "private"= "private-subnet"
        "public" = "public-subnet"
    } 
}

variable "subnet_count" {
    description = "Total Number of Subnets per VPC"
    type = number
    default = 2
  
}