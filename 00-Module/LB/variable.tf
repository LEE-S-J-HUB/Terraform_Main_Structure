variable "albs" {
    type = list(object({
        name                        = string
        internal                    = bool
        security_groups             = list(string)
        subnets                     = list(string)
        enable_deletion_protection  = bool
        tags                        = map(string)
    }))
}