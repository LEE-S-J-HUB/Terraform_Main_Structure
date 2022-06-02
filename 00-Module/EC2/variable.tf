variable "ec2" {
    type = list(object({
        identifier                  = string
        ami                         = string
        instance_type               = string
        availability_zone           = string
        subnet_id                   = string
        vpc_security_group_ids      = list(string)
        user_data                   = string
        tags                        = map(string)
        root_block_device           = list(any)
        launch_template             = map(string)
    }))
}

variable "eips" {
    type = list(object({
        identifier                  = string
        ec2_identifier              = string
        tags                        = map(string)
    }))
}