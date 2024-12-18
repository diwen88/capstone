# create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "deham19"
  }
}

# create public subnet 1 in AZ-a
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24" # 256 ip adresses  
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

# create private subnet 1 in AZ-a 
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24" # 256 ip adresses
  availability_zone = "us-west-2a"
  tags = {
    Name = "private-subnet-1"
  }
}

# create public subnet 2 in AZ-b 
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24" # 256 ip adresses
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

# create private subnet 2 in AZ-b 
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.4.0/24" # 256 ip adresses
  availability_zone = "us-west-2b"
  tags = {
    Name = "private-subnet-2"
  }
}

# create internet gateway 
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "capstone-igw"
  }
}

# public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public route table"
  }
}

# private route table 
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private route table"
  }
}

# connect public route table to internet gateway 
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Elastic IP for NAT gateway
resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  tags = {
    Name = "nat-elastic-ip"
  }
}

# create NAT gateway 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "nat-gateway"
  }
}

# connect private route table to NAT gateway 
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# connect route table to public subnet 1 
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# connect route table to private subnet 1
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

# connect route table to public subnet 2 
resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create route table to private subnet 2 
resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}
