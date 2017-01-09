output "public_subnet_azs" {
  value = [
    "${aws_subnet.public-subnet.*.availability_zone}"
  ]
}

output "public_subnet_ids" {
  value = [
    "${aws_subnet.public-subnet.*.id}"
  ]
}

output "vpc_id" {
  value = "${aws_vpc.two-tier-vpc.id}"
}