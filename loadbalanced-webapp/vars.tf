variable cidr_range_access_to_app {
  description = "list of ip ranges in cidr notation that should be able to access the app. default is the whole internet"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable ec2_ami_id {
  description = "id of ami to be used for ec2 instances"
  type        = "string"
}

variable ec2_instance_type {
  description = "type of instances to be created in auto scaling group"
  type        = "string"
}

variable number_of_instances {
  description = "mnumber of instances in the auto scaling group. specify minimum number of instances that should be running at all times ('min') and the maximum number of instances the ASG can scale to ('max'). default values are 1 & 3"
  type        = "map"

  default = {
    "min" = 1
    "max" = 3
  }
}

variable open_ports_map {
  description = "list of ports that will be opnened for the app. key is port to be opened, value internal port to be mapped. opens port 80 by default"
  type        = "map"

  default = {
    "80" = 80
  }
}

variable "protocols_map" {
  description = "contains a mapping of ports to protocol expected at that port. maps port 80 to HTTP traffic by default"
  type        = "map"

  default = {
    "80" = "HTTP"
  }
}

variable region {
  description = "id of region to create resources in; default is ap-southeast-2 (Sydney)"
  type        = "string"
  default     = "ap-southeast-2"
}

variable resource_default_tags {
  description = "map: tags that will be set on all resources that support tagging"
  type        = "map"

  default = {
    module = "loadbalanced-webapp"
  }
}

variable subnet_ids {
  description = "list of subnets where ec2 instances should be placed"
  type        = "list"
}

variable vpc_id {
  description = "id of vpc in which resources should be created"
  type        = "string"
}
