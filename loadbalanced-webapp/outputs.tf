output "elb_dns_name" {
  value = "${aws_alb.elb_webservers.dns_name}"
}
