#
##### private Subnets
#
## private Subnet on us-west-2a
#resource "aws_subnet" "private_subnet_us_east_1a" {
#  vpc_id                  = aws_vpc.cluster_vpc.id
#  cidr_block              = "10.0.32.0/20"
#  availability_zone       = "${local.aws_region}a"
#
#  tags = {
#    Name = "${var.cluster_name}-private-subnet-1a"
#  }
#}
#
## private Subnet on us-west-2b
#resource "aws_subnet" "private_subnet_us_east_1b" {
#  vpc_id                  = aws_vpc.cluster_vpc.id
#  cidr_block              = "10.0.48.0/20"
#
#  availability_zone       = "${local.aws_region}b"
#
#  tags = {
#    Name = "${var.cluster_name}-private-subnet-1b"
#  }
#}
#
## Associate subnet private_subnet_us_east_1a to private route table
#resource "aws_route_table_association" "private_subnet_us_east_1a_association" {
#  subnet_id      = aws_subnet.private_subnet_us_east_1a.id
#  route_table_id = aws_route_table.private_route_table.id
#}
#
## Associate subnet private_subnet_us_east_1b to private route table
#resource "aws_route_table_association" "private_subnet_us_east_1b_association" {
#  subnet_id      = aws_subnet.private_subnet_us_east_1b.id
#  route_table_id = aws_route_table.private_route_table.id
#}
#
#resource "aws_route_table" "private_route_table" {
#  vpc_id = aws_vpc.cluster_vpc.id
#
#  route = []
#
#  tags = {
#    Name = "private"
#  }
#}