#Criacao da VPC
resource "aws_vpc" "cris_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cris-vpc"
  }
}

#Criacao do Internet Gateway
resource "aws_internet_gateway" "cris_igw" {
  vpc_id = aws_vpc.cris_vpc.id

  tags = {
    Name = "cris-igw"
  }
}

#Criacao das Subnets
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.cris_vpc.id
  cidr_block        = "10.0.1.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "cris-subnet-public-1"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.cris_vpc.id
  cidr_block        = "10.0.1.16/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "cris-subnet-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.cris_vpc.id
  cidr_block        = "10.0.1.32/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "cris-subnet-private-2"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.cris_vpc.id
  cidr_block        = "10.0.2.0/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "cris-subnet-public-2"
  }
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.cris_vpc.id
  cidr_block        = "10.0.2.16/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "cris-subnet-private-3"
  }
}

#Criacao do ip elastico para criacao do NAT Gateway
  resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "cris-nat-eip"
  }
}

#Criacao do Nat Gateway
resource "aws_nat_gateway" "cris_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "cris-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.cris_igw
  ]
}

#Criacao da Route Table Publica
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cris_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.cris_igw.id
  }

  tags = {
    Name = "cris-route-table-public"
  }
}

#Criacao da Route Table Privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cris_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cris_nat.id
  }

  tags = {
    Name = "cris-route-table-private"
  }
}


#Associacao das Subnets com as Route Tables
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private.id
}