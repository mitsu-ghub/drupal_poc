# VPC

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_Cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge({
        Name = "${local.id_gen}-vpc"
    },
    local.common_tags) 
}

# Private Subnets

resource "aws_subnet" "private_subnets" {
    vpc_id = aws_vpc.vpc.id
    count = var.subnet_count
    cidr_block = cidrsubnet(var.vpc_Cidr,5,count.index)
    availability_zone = local.az_names[count.index]

    tags = merge({
        Name = "${local.id_gen}-${var.subnet_name["private"]}-${count.index+1}-in-${local.az_names[count.index]}"
        "Type" = "${var.subnet_name["private"]}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    },
        local.common_tags
    )
  
}

# Pulic Sunnets

resource "aws_subnet" "public_subnets" {
    count = var.subnet_count
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.vpc_Cidr,5,count.index + var.subnet_count)
    availability_zone = local.az_names[count.index]
    depends_on = [
      aws_subnet.private_subnets
    ]

    tags = merge({
        Name = "${local.id_gen}-${var.subnet_name["public"]}-${count.index+1}-in-${local.az_names[count.index]}"
        "Type" = "${var.subnet_name["public"]}"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared" 
    },
        local.common_tags
    )
  
}

# Internet Gateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${local.id_gen}-internet-gateway"
  },
  local.common_tags
  )
}

# Elastic IP

resource "aws_eip" "eip" {
  vpc      = true

   tags = merge({
    Name = "${local.id_gen}-elastic-ip"
  },
  local.common_tags
  )
}

# NAT Gateway 

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

   tags = merge({
    Name = "${local.id_gen}-NAT-gateway"
  },
  local.common_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Rote table for public subnets

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

   tags = merge({
    Name = "${local.id_gen}-public-route-table"
  },
  local.common_tags
  )
}

resource "aws_route_table_association" "public_subnet_rt" {
    for_each = tomap({for index, subnet in aws_subnet.public_subnets: index => subnet.id})
    subnet_id      = each.value
    route_table_id = aws_route_table.public-route-table.id
}

# Rote table for private subnets

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

   tags = merge({
    Name = "${local.id_gen}-private-route-table"
  },
  local.common_tags
  )
}

resource "aws_route_table_association" "private_subnet_rt" {
    for_each = tomap({for index, subnet in aws_subnet.private_subnets: index => subnet.id})
    subnet_id      = each.value
    route_table_id = aws_route_table.private-route-table.id
}