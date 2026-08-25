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