
variable "vpc_cidr_block" {
  description = "value for vpc cidr range"
  type        = string

}


variable "subnet_cidr_block" {
  type = string

}


variable "az" {
  type = string

}


variable "assign_public_ip" {
  type = bool

}



variable "ami_id" {
  description = "ami id of region ap-southeast-1"
  type        = string

}

variable "inst_type" {
  type = string

}

variable "key_pair" {
  type = string

}



