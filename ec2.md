## tf day 1
````
resource "aws_instance" "vm" {
  ami                    = "ami-0bbafdf433890644d"
  instance_type          = "t3.micro"
  key_name               = "id_rsa"
  vpc_security_group_ids = ["sg-0a7ae78370632c262"]
  user_data              = <<-EOF
    #!/bin/bash
    sudo -i
    yum install httpd -y
    systemctl start httpd 
    systemctl enable httpd 
    echo "welcome to terraform" > /var/www/html/index.html
    EOF

  tags = {
    Name = "webserver"
  }
}
````
---
## tf day 2
````
# create security group
resource "aws_security_group" "fw" {
  name   = "tf-practice-sg"
  vpc_id = "vpc-051c1a41d636a55fc"                #change vpc id

  # ingress means inbound rule
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # egress means outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# create ec2 instance
resource "aws_instance" "vm" {
 
  ami                    = "ami-0bbafdf433890644d"     # change ami id
  instance_type          = "t3.micro"
  key_name               = "id_rsa"                    # change keypair
  vpc_security_group_ids = [aws_security_group.fw.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo -i
    yum install httpd -y
    systemctl start httpd 
    systemctl enable httpd 
    echo "welcome to terraform" > /var/www/html/index.html
    EOF

  tags = {
    Name = "tf-server"
  }
}



````
