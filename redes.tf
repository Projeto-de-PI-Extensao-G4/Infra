#Criacao da VPC
resource "aws_vpc" "projeto_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "projeto-vpc"
  }
}

#Criacao do Internet Gateway
resource "aws_internet_gateway" "projeto_igw" {
  vpc_id = aws_vpc.projeto_vpc.id

  tags = {
    Name = "projeto-igw"
  }
}

#Criacao das Subnets
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.projeto_vpc.id
  cidr_block        = "10.0.1.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "projeto-subnet-public-1"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.projeto_vpc.id
  cidr_block        = "10.0.1.16/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "projeto-subnet-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.projeto_vpc.id
  cidr_block        = "10.0.1.32/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "projeto-subnet-private-2"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.projeto_vpc.id
  cidr_block        = "10.0.2.0/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "projeto-subnet-public-2"
  }
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.projeto_vpc.id
  cidr_block        = "10.0.2.16/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "projeto-subnet-private-3"
  }
}

#Criacao do ip elastico para criacao do NAT Gateway
  resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "projeto-nat-eip"
  }
}

#Criacao do Nat Gateway
resource "aws_nat_gateway" "projeto_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "projeto-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.projeto_igw
  ]
}

#Criacao da Route Table Publica
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.projeto_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.projeto_igw.id
  }

  tags = {
    Name = "projeto-route-table-public"
  }
}

#Criacao da Route Table Privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.projeto_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.projeto_nat.id
  }

  tags = {
    Name = "projeto-route-table-private"
  }
}