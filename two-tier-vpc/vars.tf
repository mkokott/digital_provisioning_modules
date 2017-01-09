variable region {
  description = "id of region to create resources in; default is ap-southeast-2 (Sydney)"
  type = "string"
  default = "ap-southeast-2"
}

variable az_appendices {
  description = "list: availability zones to create resources in; default is a & b"
  type = "list"
  default = [ "a", "b" ]
}

variable resource_default_tags {
  description = "map: tags that will be set on all resources that support tagging"
  type = "map"
  default = {
    module = "two-tier-vpc"
  }
}