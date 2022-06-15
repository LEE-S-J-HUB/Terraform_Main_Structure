#### Security Group Rule Resource creation method : import 
variable "sgrs"{
    type = list(object({
        AccountName                 = string
        SecurityGroup               = string
        Type                        = string
        Protocol                    = string
        PortRange                   = string
        Source                      = string
        Description                 = string
    }))
}

variable "scg_ids" {
    type = map(string)
  
}

#### Security Group Rule Resource creation method : import 
# variable "sgrs" {
#     type = list(object({
#         security_group_identifier   = string
#         rule                        = string
#         rule_target                 = object(
#             {
#                 cidr_blocks                     = list(string)
#                 ipv6_cidr_blocks                = list(string)
#                 prefix_list_ids                 = list(string)
#                 source_security_group_id        = string
#             }
#         )
#         description                 = string
#     }))
# }

