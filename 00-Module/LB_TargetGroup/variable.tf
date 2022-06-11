variable "tgs" {
    type = list(object({
        name        = string
        port        = number
        protocol    = string
        target_type = string
        vpc_id      = string
    }))
}

variable "tgas" {
    type = list(object({
        target_group_identifier = string
        target_id               = string
        port                    = number
    }))
}
