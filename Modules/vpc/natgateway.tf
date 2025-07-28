########################################
# 1. Elastic IPs for the NAT Gateways
########################################
resource "aws_eip" "nat_1a" {
  domain = "vpc"
  tags = { Name = "nat-eip-1a" }
}

resource "aws_eip" "nat_1b" {
  domain = "vpc"
  tags = { Name = "nat-eip-1b" }
}


########################################
# 2. NAT Gateways in each public subnet
########################################
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_subnet_us-east-1a.id
  tags = { Name = "nat-1a" }
}

resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_1b.id
  subnet_id     = aws_subnet.public_subnet_us-east-1b.id
  tags = { Name = "nat-1b" }
}

########################################
# 3. Route tables for the private subnets

# Default route --> 0.0.0.0/0 to NAT 
########################################
resource "aws_route_table" "private_rt_netgateway_1a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }
  tags = { Name = "private-rt-natgateway-1a" }
}

resource "aws_route_table" "private_rt_netgateway_1b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }
  tags = { Name = "private-rt-natgateway-1b" }
}

########################################
# 4. Associate private subnets → NAT RTs
########################################
resource "aws_route_table_association" "private_rt_assoc_1a" {
  subnet_id      = aws_subnet.private_subnet_us-east-1a.id
  route_table_id = aws_route_table.private_rt_netgateway_1a.id
}

resource "aws_route_table_association" "private_rt_assoc_1b" {
  subnet_id      = aws_subnet.private_subnet_us-east-1b.id
  route_table_id = aws_route_table.private_rt_netgateway_1b.id
}