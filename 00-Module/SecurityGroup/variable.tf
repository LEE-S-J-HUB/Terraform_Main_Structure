variable "scg" {
    type = list(object({
        identifier          = string
        vpc_id              = string
        tags                = map(string)
    }))
}