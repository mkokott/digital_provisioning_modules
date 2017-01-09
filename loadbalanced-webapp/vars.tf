variable region {
  description = "id of region to create resources in; default is ap-southeast-2 (Sydney)"
  type        = "string"
  default     = "ap-southeast-2"
}

variable cidr_range_access_to_app {
  description = "list of ip ranges in cidr notation that should be able to access the app. default is the whole internet"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable open_ports_map {
  description = "list of ports that will be opnened for the app. key is port to be opened, value internal port to be mapped. defaults are 80 & 443 without remapping"
  type        = "map"

  default = {
    "80"  = 80
    "443" = 443
  }
}

variable subnet_ids {
  description = "list of subnets where ec2 instances should be placed"
  type = "list"
}

variable vpc_id {
  description = "id of vpc in which resources should be created"
  type = "string"
}

variable resource_default_tags {
  description = "map: tags that will be set on all resources that support tagging"
  type        = "map"

  default = {
    module = "loadbalanced-webapp"
  }
}
