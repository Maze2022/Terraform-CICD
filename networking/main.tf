#---------networking/main.tf

data "aws_availability_zones" "available" {}

resource "random_uuid" "number" {}


resource "aws_vpc" "wk24_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "wk24_vpc-${random_uuid.number.result}"
  }
}

#Public subnets
resource "aws_subnet" "luit_public_subnets" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.wk24_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "luit_public_subnets_${count.index + 1}"
  }
}

#Internet gateway
resource "aws_internet_gateway" "maze_igw" {
  vpc_id = aws_vpc.wk24_vpc.id

  tags = {
    Name = "maze_igw"
  }
}

resource "aws_default_route_table" "default_wk24_public_rt" {
  default_route_table_id = aws_vpc.wk24_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.maze_igw.id
  }
  tags = {
    Name = "wk24_public_rt"
  }
}

#Associate public subnets with routing table
resource "aws_route_table_association" "Public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.luit_public_subnets[count.index].id
  route_table_id = aws_default_route_table.default_wk24_public_rt.id
}


resource "aws_security_group" "vpc_sg" {
  name        = "luit_sg"
  description = "Security group to allow inbound HTTP traffic"
  vpc_id      = aws_vpc.wk24_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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