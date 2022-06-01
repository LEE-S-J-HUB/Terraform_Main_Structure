variable "vpcs" {
    type    = list(object({
        vpc_identifier          = string
        igw_identifier          = string
        cidr_block              = string
        enable_dns_hostnames    = bool
        enable_dns_support      = bool
        instance_tenancy        = string
        attach_igw              = bool
        vpc_tags                = map(string)
        igw_tags                = map(string)
    }))
}

variable "subnets" {
    type    = list(object({
        subnet_identifier       = string
        vpc_identifier          = string
        availability_zone       = string
        cidr_block              = string
        subnet_tags             = map(string)
        attach_ngw              = bool
        ngw_identifier          = string
        eip_identifier          = string
        ngw_tags                = map(string)
        eip_tags                = map(string)
    }))
}