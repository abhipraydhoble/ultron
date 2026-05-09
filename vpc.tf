# create vpc
resource "aws_vpc" "net" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "vpc-tf"
  }
}

# create subnet
resource "aws_subnet" "pub" {
  vpc_id                  = aws_vpc.net.id
  cidr_block              = "192.168.0.0/21"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "igw-tf"
  }
}


# create route table

resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "RT-Public"
  }

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

}


# associate subnet with rt
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt-1.id
}
