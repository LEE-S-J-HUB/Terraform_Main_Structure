variable "sgrs" {
    type = list(object({
        security_group_identifier   = string
        rule                        = string
        rule_target                 = object(
            {
                cidr_blocks                     = list(string)
                ipv6_cidr_blocks                = list(string)
                prefix_list_ids                 = list(string)
                source_security_group_id        = string
            }
        )
        description                 = string
    }))
}
# variable "security_group_rule_list" {
#     type    = list(object({
#         security_group_identifier           = string
#         rule_type                           = string
#         source_type                         = string
#         from_port                           = number
#         to_port                             = number
#         protocol                            = string
#         cidr_block                          = string
#         source_security_group_identifier    = string
#         description                         = string
#     }))
# }