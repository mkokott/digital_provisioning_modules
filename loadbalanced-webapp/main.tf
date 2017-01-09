# create security groups
resource "aws_security_group" "allow_ingress_http_traffic" {
  name        = "sg_webservers"
  description = "allows incoming http & https traffic"
  tags        = "${var.resource_default_tags}"
}

# egress for all traffic for ELB
resource "aws_security_group" "allow_egress_all_traffic" {
  name        = "sg_unrestricted_egress"
  description = "allows all outgoing traffic"
  tags        = "${var.resource_default_tags}"
}

resource "aws_security_group_rule" "ingress_rules" {
  type              = "ingress"
  protocol          = "tcp"
  count             = "${length(var.open_ports_map)}"
  from_port         = "${element(keys(var.open_ports_map), count.index)}"
  to_port           = "${lookup(var.open_ports_map, element(keys(var.open_ports_map), count.index))}"
  cidr_blocks       = ["${var.cidr_range_access_to_app}"]
  security_group_id = "${aws_security_group.allow_ingress_http_traffic.id}"
}

resource "aws_security_group_rule" "egress_rules" {
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.allow_egress_all_traffic.id}"
}
