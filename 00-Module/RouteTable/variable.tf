variable "rts" {
    type    = list(object({
        rt_identifier   = string
        vpc_id          = string
        tags            = map(string)
    }))
}

variable "rtas" {
    type    = list(object({
        rt_identifier           = string
        association_subent_id   = string
    }))
}

variable "rtrs" {
    type    = list(object({
        route_table_identifier  = string
        destination_cidr_block  = string
        target_resource         = map(string)
    }))
}