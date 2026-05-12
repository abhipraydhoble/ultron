output "public_ip" {
  value = aws_instance.vm.public_ip
}

output "vpc_id" {
  value = aws_vpc.net.id
}

output "subnet_id" {
  value = aws_subnet.pub.id 
}

output "sg_id" {
  value = aws_security_group.firewall.id
}
