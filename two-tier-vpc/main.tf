# create a single VPC for all resources
resource "aws_vpc" "two-tier-vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = "${var.resource_default_tags}"
}

# create an internet gateway so that resources within the VPC can connect to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.two-tier-vpc.id}"
  tags   = "${var.resource_default_tags}"
}

# create public & private subnets

## public subnet
resource "aws_subnet" "public-subnet" {
  count             = 2
  availability_zone = "${var.region}${element(var.az_appendices, count.index)}"
  vpc_id            = "${aws_vpc.two-tier-vpc.id}"
  cidr_block        = "10.0.${count.index}.0/24"
  tags              = "${var.resource_default_tags}"
}

## private subnet
resource "aws_subnet" "private-subnet" {
  count             = 2
  availability_zone = "${var.region}${element(var.az_appendices, count.index)}"
  vpc_id            = "${aws_vpc.two-tier-vpc.id}"
  cidr_block        = "10.0.1${count.index}.0/24"
  tags              = "${var.resource_default_tags}"
}

# create routing tables for subnets

## route tables
resource "aws_route_table" "rt-public-subnet" {
  vpc_id = "${aws_vpc.two-tier-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

## associate route tables with subnets
resource "aws_route_table_association" "rt-public-subnet" {
  count          = 2
  subnet_id      = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-public-subnet.id}"
}
