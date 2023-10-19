resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      name = "aws-test-vpc"
  }
}

# Public

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# Internet & NAT Gateway

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-internetgw"
  }
}

resource "aws_eip" "test_eip" {
  instance = aws_instance.linux.id
  domain   = "vpc"
}

resource "aws_nat_gateway" "test_ngw" {
  allocation_id = aws_eip.test_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on = [aws_internet_gateway.test_igw]
}

# Route Table for public subnet

resource "aws_route_table" "rt_for_pubsub" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt_for_pubsub.id
}

# route table for private subnet

resource "aws_route_table" "rt_for_prisub" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test_ngw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt_for_prisub.id
}

