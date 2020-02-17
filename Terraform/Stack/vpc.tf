#VPC
resource "aws_vpc" "bs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

#Internet Gateway
resource "aws_internet_gateway" "bs_igw" {
  vpc_id = aws_vpc.bs_vpc.id
}

#Subnet Definitions start here
resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.bs_vpc.id
  cidr_block        = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.bs_vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }

}

resource "aws_subnet" "db_subnet" {
  count             = length(var.db_subnets_cidr)
  vpc_id            = aws_vpc.bs_vpc.id
  cidr_block        = element(var.db_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "db-subnet-${count.index + 1}"
  }

}

#Route table to attach the Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.bs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bs_igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets for internet access

resource "aws_route_table_association" "a" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}


# VPC endpoints to allow ssm as per https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = aws_vpc.bs_vpc.id
  service_name        = "com.amazonaws.eu-west-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.endpoints_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.bs_vpc.id
  service_name        = "com.amazonaws.eu-west-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.endpoints_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.bs_vpc.id
  service_name        = "com.amazonaws.eu-west-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.endpoints_sg.id]
  private_dns_enabled = true
}

