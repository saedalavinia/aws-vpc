# --------------------- Public Route Table Block ---------------------
resource "aws_route_table" "public" {
    count                   =   "${length(var.public_subnet_cidrs) > 0 ? 1 : 0}"
    vpc_id                  =   "${aws_vpc.default.id}"
    route                       {
                                    cidr_block = "0.0.0.0/0"
                                    gateway_id = "${aws_internet_gateway.default.id}"
                                }

    tags                    =   "${merge(var.tags, map(
                                "Name" , "Public-route-table@${var.vpc_name}"
                                ))}"
}

resource "aws_route_table_association" "public" {
    count                   =   "${length(var.public_subnet_cidrs)}"
    subnet_id               =   "${element(aws_subnet.public_subnets.*.id, count.index)}"
    route_table_id          =   "${aws_route_table.public.id}"
}
# ----------------------------------------------------------------------


# --------------------- Private Route Table Block ---------------------
## This module currently does not allow the number of private subnets to be less than the number of public subnets
resource "aws_eip" "nat" {
    count                   =   "${length(var.private_subnet_cidrs) > 0 ? length(var.public_subnet_cidrs) : 0}"
    vpc                     =   true
    depends_on              =   ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "default" {
    count                   =   "${length(var.private_subnet_cidrs) > length(data.aws_availability_zones.available.names) ? length(data.aws_availability_zones.available.names) : length(var.private_subnet_cidrs)}"
    allocation_id           =   "${element(aws_eip.nat.*.id,count.index)}"
    subnet_id               =   "${element(aws_subnet.public_subnets.*.id, count.index)}"

    tags                    =   "${merge(var.tags, map(
                                "Name" , "Nat-Gateway${count.index+1}@${var.vpc_name}"
                                ))}"

    depends_on              =   ["aws_internet_gateway.default"]
}


resource "aws_route_table" "private" {
    count                   =   "${length(var.private_subnet_cidrs) > length(data.aws_availability_zones.available.names) ? length(data.aws_availability_zones.available.names) : length(var.private_subnet_cidrs)}"  
    vpc_id                  =   "${aws_vpc.default.id}"
    route                       {
                                    cidr_block = "0.0.0.0/0"
                                    gateway_id = "${element(aws_nat_gateway.default.*.id,count.index)}"
                                }

    tags                    =   "${merge(var.tags, map(
                                "Name" , "Private-route-table${count.index+1}@${var.vpc_name}"
                                ))}"
}

resource "aws_route_table_association" "private" {
    count                   =   "${length(var.private_subnet_cidrs) > length(data.aws_availability_zones.available.names) ? length(data.aws_availability_zones.available.names) : length(var.private_subnet_cidrs)}"  
    subnet_id               =   "${element(aws_subnet.private_subnets.*.id, count.index)}"
    route_table_id          =   "${element(aws_route_table.private.*.id,count.index)}"
    
}
# ----------------------------------------------------------------------
