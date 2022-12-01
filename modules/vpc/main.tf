data "aws_region" "current" {}

locals {
  aws_region  = data.aws_region.current.name
}

# Example VPC
resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = {
        Name = "${var.cluster_name}-igw"
    }
}

# Route to Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.cluster_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

## Route to NAT Gateway
#resource "aws_route" "private_access" {
#  route_table_id         = aws_route_table.private_route_table.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id             = aws_nat_gateway.gw.id
#}

##############################
# NAT Gateway
##############################

resource "aws_eip" "ip" {
  vpc   = true

  tags = {
    Name = "IP NAT Gateway ${var.cluster_name}"
  }
}

#resource "aws_nat_gateway" "gw" {
#  allocation_id = aws_eip.ip.id
#  subnet_id     = aws_subnet.private_subnet_us_east_1a.id
#  connectivity_type = "public"
#  tags = {
#    Name = "NAT Gateway ${var.cluster_name}"
#  }
#}
