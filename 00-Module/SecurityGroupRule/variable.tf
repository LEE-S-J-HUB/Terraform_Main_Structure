variable "sgrs" {
    type = list(object({
        security_group_identifier   = string
        rule                        = string
        rule_target                 = map(list(string))
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