# --------------------- VPC Block ---------------------
resource "aws_vpc" "default" {
    cidr_block              =   "${var.vpc_cidr}"
    enable_dns_hostnames    =   true
    tags                    =  "${merge(var.tags, map(
                                "Name" , "${var.vpc_name}"
                                ))}"
}


#  Internet Gateway Block 
resource "aws_internet_gateway" "default" {
    vpc_id                  =   "${aws_vpc.default.id}"
    tags                    =   "${merge(var.tags, map(
                                 "Name" , "Internet-gatewat@${var.vpc_name}"
                                ))}"
}
# --------------------------------------------------------



# --------------------- Public Subnet Block ---------------------
resource "aws_subnet" "public_subnets" {
    count                   =  "${length(var.public_subnet_cidrs)}"
    vpc_id                  =  "${aws_vpc.default.id}"
    cidr_block              =   "${var.public_subnet_cidrs[count.index]}"
    map_public_ip_on_launch =   true
    availability_zone       =   "${data.aws_availability_zones.available.names[count.index%length(data.aws_availability_zones.available.names)]}"
    tags                    =   "${merge(var.tags, map(
                                "Name" , "public-sunnet${count.index+1}-az${count.index%length(data.aws_availability_zones.available.names)+1}@${var.vpc_name}"
                                ))}"
}
# --------------------------------------------------------


# --------------------- Private Subnet Block ---------------------
resource "aws_subnet" "private_subnets" {
    count                   =   "${length(var.private_subnet_cidrs)}"
    vpc_id                  =   "${aws_vpc.default.id}"
    cidr_block              =   "${var.private_subnet_cidrs[count.index]}"
    map_public_ip_on_launch =   false
    availability_zone       =   "${data.aws_availability_zones.available.names[count.index%length(data.aws_availability_zones.available.names)]}"
    tags                    =   "${merge(var.tags, map(
                                "Name" , "private-sunnet${count.index+1}-az${count.index%length(data.aws_availability_zones.available.names)+1}@${var.vpc_name}"
                                ))}"
}
# --------------------------------------------------------


