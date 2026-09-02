# SECURITY GROUP - WEBSERVER

resource "aws_security_group" "webserver" {
  name        = "cris-sg-webserver"
  description = "Security Group das instancias Web Server"
  vpc_id      = aws_vpc.cris_vpc.id

  tags = {
    Name = "cris-sg-webserver"
  }
}


# HTTP - React pelo load balancer
resource "aws_vpc_security_group_ingress_rule" "webserver_http" {
  security_group_id = aws_security_group.webserver.id

  referenced_security_group_id = aws_security_group.load_balancer.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "HTTP - acesso pelo Load Balancer"
}


# SSH - Webserver
resource "aws_vpc_security_group_ingress_rule" "webserver_ssh" {
  security_group_id = aws_security_group.webserver.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH - acesso administrativo"
}


# SECURITY GROUP - BACKEND


resource "aws_security_group" "backend" {
  name        = "cris-sg-backend"
  description = "Security Group das instancias Backend"
  vpc_id      = aws_vpc.cris_vpc.id

  tags = {
    Name = "cris-sg-backend"
  }
}


# Spring Boot
resource "aws_vpc_security_group_ingress_rule" "backend_spring" {
  security_group_id = aws_security_group.backend.id

  referenced_security_group_id = aws_security_group.webserver.id

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  description = "Spring Boot - acesso dos Web Servers"
}


# SSH - Backend
resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  security_group_id = aws_security_group.backend.id

  referenced_security_group_id = aws_security_group.webserver.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH - acesso administrativo via Web Server"
}

# SECURITY GROUP - DATABASE


resource "aws_security_group" "database" {
  name        = "cris-sg-database"
  description = "Security Group da instancia MySQL"
  vpc_id      = aws_vpc.cris_vpc.id

  tags = {
    Name = "cris-sg-database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_mysql" {
  security_group_id = aws_security_group.database.id

  referenced_security_group_id = aws_security_group.backend.id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"

  description = "MySQL - acesso dos Backends"
}

resource "aws_vpc_security_group_ingress_rule" "database_ssh" {
  security_group_id = aws_security_group.database.id

  referenced_security_group_id = aws_security_group.webserver.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH - acesso administrativo via Web Server"
}

#Grupo de seguranca pro Load Balancer

resource "aws_security_group" "load_balancer" {
  name        = "cris-sg-load-balancer"
  description = "Security Group do Application Load Balancer"
  vpc_id      = aws_vpc.cris_vpc.id

  tags = {
    Name = "cris-sg-load-balancer"
  }
}


# HTTP - Internet pra dentro do ALB
resource "aws_vpc_security_group_ingress_rule" "load_balancer_http" {
  security_group_id = aws_security_group.load_balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "HTTP - acesso publico ao Load Balancer"
}