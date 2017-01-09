# create security groups
resource "aws_security_group" "allow_ingress_http_traffic" {
  name        = "sg_webservers"
  description = "allows incoming http & https traffic"
  vpc_id      = "${var.vpc_id}"
  tags        = "${var.resource_default_tags}"
}

# egress for all traffic for ELB
resource "aws_security_group" "allow_egress_all_traffic" {
  name        = "sg_unrestricted_egress"
  description = "allows all outgoing traffic"
  vpc_id      = "${var.vpc_id}"
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
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.allow_egress_all_traffic.id}"
}

# create EC2 instances in auto scaling groups
## launch confguration of web servers
resource "aws_launch_configuration" "launch_config_webservers" {
  image_id                    = "${var.ec2_ami_id}"
  instance_type               = "${var.ec2_instance_type}"
  security_groups             = ["${aws_security_group.allow_ingress_http_traffic.id}"]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

## auto scaling group for web servers
resource "aws_autoscaling_group" "auto_scaling_group_webservers" {
  launch_configuration = "${aws_launch_configuration.launch_config_webservers.id}"

  # ! vpc-zone := subnet-id !
  vpc_zone_identifier = ["${var.subnet_ids}"]
  min_size            = "${lookup(var.number_of_instances, "min")}"
  max_size            = "${lookup(var.number_of_instances, "max")}"
  load_balancers      = ["${aws_elb.elb_webservers.id}"]
  health_check_type   = "ELB"
}

# elastic load balancer for web servers
resource "aws_elb" "elb_webservers" {
  name    = "webservers-elb"
  subnets = ["${var.subnet_ids}"]

  security_groups = [
    "${aws_security_group.allow_ingress_http_traffic.id}",
    "${aws_security_group.allow_egress_all_traffic.id}",
  ]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
}
