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

