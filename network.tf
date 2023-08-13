//Criação da Virtual Private Network(VPC)
resource "aws_vpc" "vpc-criada" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "minha-vpc"
  }
}
//Criação das subredes 
resource "aws_subnet" "public_subnet" {
  depends_on              = [aws_vpc.vpc-criada]
  vpc_id                  = aws_vpc.vpc-criada.id
  cidr_block              = var.cidr_subnet[0]
  availability_zone       = var.zones[0]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "subnet-publica"
  }
}

resource "aws_subnet" "private_subnet" {
  depends_on        = [aws_vpc.vpc-criada]
  vpc_id            = aws_vpc.vpc-criada.id
  cidr_block        = var.cidr_subnet[1]
  availability_zone = var.zones[1]
  tags = {
    Name = "subnet-privada"
  }
}

//Criação internet gateway para poder conectar a internet
resource "aws_internet_gateway" "gateway_padrao" {
  depends_on = [aws_vpc.vpc-criada]
  vpc_id     = aws_vpc.vpc-criada.id
  tags = {
    "Name" = "Gateway da vpc"
  }
}

//Criação NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  depends_on    = [aws_subnet.public_subnet, aws_eip.eip]
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.eip.id
}
//endereço para o nat gateway
resource "aws_eip" "eip" {
  vpc = true
}

//Criação da tabela de rotas
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.vpc-criada.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_padrao.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc-criada.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "privateRouteTable"
  }
}
//Associacao da tabela com as subredes
resource "aws_route_table_association" "route_association_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "route_association_private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
