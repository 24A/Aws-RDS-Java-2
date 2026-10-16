# ---------------------------------------------------------
# VPC
# ---------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


# ---------------------------------------------------------
# Public Subnets
# ---------------------------------------------------------

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1"
    Tier = "Public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
    Tier = "Public"
  }
}


# ---------------------------------------------------------
# Application Private Subnets
# ---------------------------------------------------------

resource "aws_subnet" "app_private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_private_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-app-private-subnet-1"
    Tier = "Application"
  }
}

resource "aws_subnet" "app_private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_private_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-app-private-subnet-2"
    Tier = "Application"
  }
}


# ---------------------------------------------------------
# Database Private Subnets
# ---------------------------------------------------------

resource "aws_subnet" "db_private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_private_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-db-private-subnet-1"
    Tier = "Database"
  }
}

resource "aws_subnet" "db_private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_private_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-db-private-subnet-2"
    Tier = "Database"
  }
}


# ---------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


# ---------------------------------------------------------
# Elastic IP for NAT Gateway
# ---------------------------------------------------------

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}


# ---------------------------------------------------------
# NAT Gateway
# ---------------------------------------------------------

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}


# ---------------------------------------------------------
# Public Route Table
# ---------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


# ---------------------------------------------------------
# Public Route Table Associations
# ---------------------------------------------------------

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


# ---------------------------------------------------------
# Application Private Route Table
# ---------------------------------------------------------

resource "aws_route_table" "app_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-app-private-rt"
  }
}


# ---------------------------------------------------------
# Application Route Table Associations
# ---------------------------------------------------------

resource "aws_route_table_association" "app_private_1" {
  subnet_id      = aws_subnet.app_private_1.id
  route_table_id = aws_route_table.app_private.id
}

resource "aws_route_table_association" "app_private_2" {
  subnet_id      = aws_subnet.app_private_2.id
  route_table_id = aws_route_table.app_private.id
}


# ---------------------------------------------------------
# Database Private Route Table
# ---------------------------------------------------------

resource "aws_route_table" "db_private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-db-private-rt"
  }
}


# ---------------------------------------------------------
# Database Route Table Associations
# ---------------------------------------------------------

resource "aws_route_table_association" "db_private_1" {
  subnet_id      = aws_subnet.db_private_1.id
  route_table_id = aws_route_table.db_private.id
}

resource "aws_route_table_association" "db_private_2" {
  subnet_id      = aws_subnet.db_private_2.id
  route_table_id = aws_route_table.db_private.id
}