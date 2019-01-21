variable "vpc_cidr" {
    description = "CIDR block VPC"
    default = "10.0.0.0/8"
}

variable "vpc_name" {
    description = "VPC Name"
    default = "default"
}


variable "public_subnet_cidrs" {
    type = "list"
    description = "CIDR for the Public Subnet"
    default = []
}


variable "tags" {
  type = "map"
  default = {}
}

variable "private_subnet_cidrs" {
    type = "list"
    description = "CIDR for the Private Subnet"
    default = []
}