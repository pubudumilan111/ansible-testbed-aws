resource "aws_vpc" "ansible_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ansible-vpc"
  }
}

resource "aws_subnet" "ansible_public_subnet" {
  vpc_id                  = aws_vpc.ansible_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "ansible-public-subnet"
  }
}

resource "aws_subnet" "ansible_private_subnet" {
  vpc_id            = aws_vpc.ansible_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "ansible-private-subnet"
  }
}

resource "aws_internet_gateway" "ansible_igw" {
  vpc_id = aws_vpc.ansible_vpc.id
}

resource "aws_route_table" "ansible_public_route_table" {
  vpc_id = aws_vpc.ansible_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible_igw.id
  }
}

resource "aws_route_table_association" "ansible_public_route_table_association" {
  subnet_id      = aws_subnet.ansible_public_subnet.id
  route_table_id = aws_route_table.ansible_public_route_table.id
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "Security group for Ansible instances"
  vpc_id      = aws_vpc.ansible_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "host_sg" {
  name        = "host-sg"
  description = "Security group for host instance"
  vpc_id      = aws_vpc.ansible_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ansible_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "nat_eip" {

}

resource "aws_nat_gateway" "ansible_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.ansible_public_subnet.id
}

resource "aws_route_table" "ansible_private_route_table" {
  vpc_id = aws_vpc.ansible_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ansible_nat_gateway.id
  }
}

resource "aws_route_table_association" "ansible_private_route_table_association" {
  subnet_id      = aws_subnet.ansible_private_subnet.id
  route_table_id = aws_route_table.ansible_private_route_table.id
}
