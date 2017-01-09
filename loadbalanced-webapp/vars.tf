variable region {
  description = "id of region to create resources in; default is ap-southeast-2 (Sydney)"
  type        = "string"
  default     = "ap-southeast-2"
}

variable remote_state_backend {
  description = "source system that contains the remote state for subnets"
  type        = "string"
  default     = "s3"
}

variable remote_state_config {
  description = "configuration for remote state containing subnet information. see mandatory keys for S3 below"
  type        = "map"

  default = {
    bucket = ""
    key    = ""
    region = ""
  }
}

variable public_subnets_key {
  description = "key that contains information on public subnets in remote state configured in remote_state_config."
  type       = "string"
  default    = "data.terraform_remote_state.public_subnet_ids"
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

variable resource_default_tags {
  description = "map: tags that will be set on all resources that support tagging"
  type        = "map"

  default = {
    module = "loadbalanced-webapp"
  }
}
