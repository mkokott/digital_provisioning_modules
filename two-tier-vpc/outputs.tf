output "vpc_id" {
  value = "${aws_vpc.two-tier-vpc.id}"
}

output "public_subnet_ids" {
  value = [
    "${aws_subnet.public-subnet.id}",
  ]
}

output "public_subnet_azs" {
  value = [
    "${aws_subnet.public-subnet.availability_zone}",
  ]
}

output "webtier_security_group" {
  value = "${aws_security_group.allow_ingress_http_traffic.id}"
}

output "elb_security_group" {
  value = "${aws_security_group.allow_egress_all_traffic.id}"
}
