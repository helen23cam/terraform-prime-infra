resource "aws_vpc" "Prime" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Prime"
  }
}

# creating igw
# # https://registry.terraform.io/providers/aaronfeng/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "Prime-igw" {
  vpc_id = aws_vpc.Prime.id

  tags = {
    Name = "Prime-igw"
  }
}

# creating pub sub 1
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet.html
resource "aws_subnet" "Prime-pub1" {
  vpc_id            = aws_vpc.Prime.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Prime-pub1"
  }
}

# creating pub-sub2
resource "aws_subnet" "Prime-pub2" {
  vpc_id            = aws_vpc.Prime.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Prime-pub2"
  }
}

# creat a pub rt
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table.html
resource "aws_route_table" "Prime-pub-route-table" {
  vpc_id = aws_vpc.Prime.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Prime-igw.id
  }

  tags = {
    Name = "Prime-pub-route-table"
  }
}

# associating subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet.html
resource "aws_route_table_association" "prime-pub1" {
  subnet_id      = aws_subnet.Prime-pub1.id
  route_table_id = aws_route_table.Prime-pub-route-table.id
}

resource "aws_route_table_association" "prime-pub2" {
  subnet_id      = aws_subnet.Prime-pub2.id
  route_table_id = aws_route_table.Prime-pub-route-table.id
}

# Creating private subnet1
resource "aws_subnet" "Prime-private1" {
  vpc_id            = aws_vpc.Prime.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Prime-private1"
  }
}

# Creating private subnet2
resource "aws_subnet" "Prime-private2" {
  vpc_id            = aws_vpc.Prime.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Prime-private2"
  }
}

# creating a private routee table
resource "aws_route_table" "private-route_table" {
  vpc_id = aws_vpc.Prime.id

  route = []

  tags = {
    Name = "prime-private-route-table"
  }
}

# associating private route table
resource "aws_route_table_association" "prime-private1" {
  subnet_id      = aws_subnet.Prime-private1.id
  route_table_id = aws_route_table.private-route_table.id
}

# associating private route table
resource "aws_route_table_association" "prime-private2" {
  subnet_id      = aws_subnet.Prime-private2.id
  route_table_id = aws_route_table.private-route_table.id
}
