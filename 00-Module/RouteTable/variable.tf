variable "rt" {
    type    = list(object({
        rt_identifier   = string
        vpc_id          = string
        tags            = map(string)
    }))
}

variable "rta" {
    type    = list(object({
        rt_identifier           = string
        association_subent_id   = string
    }))
}

variable "rtr" {
    type    = list(object({
        route_table_identifier  = string
        destination_cidr_block  = string
        target_resource         = map(string)
    }))
}