resource "aws_vpc" "net" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "vpc-tf"
  }
}


resource "aws_subnet" "pub" {
  vpc_id                  = aws_vpc.net.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = var.assign_public_ip
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
  ingress {
    from_port   = 80
    to_port     = 80
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
  ami                    = var.ami_id
  instance_type          = var.inst_type
  key_name               = var.key_pair
  user_data              = <<-EOF
    #!/bin/bash 
    sudo -i
    yum install nginx -y
    systemctl start nginx
    systemctl enable nginx
    EOF
  subnet_id              = aws_subnet.pub.id
  vpc_security_group_ids = [aws_security_group.firewall.id]

  tags = {
    Name = "instance-01"
  }
}


