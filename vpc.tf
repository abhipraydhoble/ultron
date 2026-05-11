resource "aws_vpc" "net" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "vpc-tf"
  }
}


resource "aws_subnet" "pub" {
  vpc_id                  = aws_vpc.net.id
  cidr_block              = "192.168.0.0/22"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "igw-vpc-tf"
  }

}


resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "rt-public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "rta-1" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt-1.id
}



resource "aws_security_group" "firewall" {
  name   = "vpc-tf-sg"
  vpc_id = aws_vpc.net.id

  ingress {
    from_port   = 22
    to_port     = 22
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



resource "aws_instance" "vm" {
  ami                    = "ami-04a8a2b994a2a7176"
  instance_type          = "t3.micro"
  key_name               = "id_rsa"
  subnet_id              = aws_subnet.pub.id
  vpc_security_group_ids = [aws_security_group.firewall.id]

  tags = {
    Name = "instance-01"
  }
}
