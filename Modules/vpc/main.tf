# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤ VPC ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤
# Flow -->
# ➤ VPC -- Public Private Subnet --> IG --> Router to the IG 
# ➤ VPC creation --> 
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "poc-vpc"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# AZ - "us-east-1a"
# Creating teh Public and Private Subnet
resource "aws_subnet" "public_subnet_us-east-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "poc-public-subnet-east-1a"
  }
}

resource "aws_subnet" "private_subnet_us-east-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "poc-private-subnet-east-1a"
  }
}

# Attching the IG 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "poc-main-igw"
  }
}

# Attaching the Router Table to the IG inside VPC 
resource "aws_route_table" "aws_internet_gateway_router" {
  vpc_id = aws_vpc.main.id

  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "poc-public-route-table"
  }
}

# Attach the public subnet to the route table
resource "aws_route_table_association" "public_subnet_assoc_east_1a" {
  subnet_id      = aws_subnet.public_subnet_us-east-1a.id
  route_table_id = aws_route_table.aws_internet_gateway_router.id
}


# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# 2nd AZ: us-west-1
resource "aws_subnet" "public_subnet_us-east-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "poc-public-subnet-east-1b"
  }
}

resource "aws_subnet" "private_subnet_us-east-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "poc-private-subnet-east-1b"
  }
}

# Attach the new public subnet to the same route table already created
resource "aws_route_table_association" "public_subnet_assoc_east_1b" {
  subnet_id      = aws_subnet.public_subnet_us-east-1b.id
  route_table_id = aws_route_table.aws_internet_gateway_router.id
}
