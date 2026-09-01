
# EC2 - WEBSERVER 01

resource "aws_instance" "webserver01" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"

  subnet_id = aws_subnet.public_1.id

  associate_public_ip_address = true

  key_name = "vockey"
  vpc_security_group_ids = [
    aws_security_group.webserver.id
  ]

  tags = {
    Name = "webserver01"
  }
}


# EC2 - WEBSERVER 02

resource "aws_instance" "webserver02" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"

  subnet_id = aws_subnet.public_2.id

  associate_public_ip_address = true

key_name = "vockey"
  vpc_security_group_ids = [
    aws_security_group.webserver.id
  ]

  tags = {
    Name = "webserver02"
  }
}


# EC2 - BACKEND 01

resource "aws_instance" "backend01" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"

  subnet_id = aws_subnet.private_1.id

key_name = "vockey"
  vpc_security_group_ids = [
    aws_security_group.backend.id
  ]

  tags = {
    Name = "backend01"
  }
}


# EC2 - BACKEND 02

resource "aws_instance" "backend02" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"

  subnet_id = aws_subnet.private_2.id

key_name = "vockey"
  vpc_security_group_ids = [
    aws_security_group.backend.id
  ]

  tags = {
    Name = "backend02"
  }
}


# EC2 - DATABASE 01

resource "aws_instance" "database01" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.small"

  subnet_id = aws_subnet.private_3.id

key_name = "vockey"
  vpc_security_group_ids = [
    aws_security_group.database.id
  ]

  tags = {
    Name = "database01"
  }
}