locals {
    sgrs_target = {
        cidr_blocks                     = null
        ipv6_cidr_blocks                = null
        prefix_list_ids                 = null
        source_security_group_id        = null
    }
    tags        = data.terraform_remote_state.local.outputs.global_environment_tags
    vpc_id      = data.terraform_remote_state.VPC_Subnet.outputs.vpc_ids
}

module "SecurityGroup" {
    source          = "../00-Module/SecurityGroup"
    scg             = [
        {
            identifier       = format("${local.tags["scg"].Name}-%s", "bestion")
            vpc_id           = local.vpc_id["${format("${local.tags["vpc"].Name}-%s", "pub")}"]
            tags                = merge( local.tags["scg"],
                {
                    "Name" = format("${local.tags["scg"].Name}-%s", "bestion")
                }
            )
        },
        {
            identifier       = format("${local.tags["scg"].Name}-%s", "web")
            vpc_id           = local.vpc_id["${format("${local.tags["vpc"].Name}-%s","pub")}"]
            tags                = merge( local.tags["scg"],
                {
                    "Name" = format("${local.tags["scg"].Name}-%s", "web")
                }
            )
        },
        {
            identifier       = format("${local.tags["scg"].Name}-%s", "xalb")
            vpc_id           = local.vpc_id["${format("${local.tags["vpc"].Name}-%s","pub")}"]
            tags                = merge( local.tags["scg"],
                {
                    "Name" = format("${local.tags["scg"].Name}-%s", "xalb")
                }
            )
        }
    ]
}

locals{
    scg_ids = module.SecurityGroup.scg_ids
    security_group_list      = csvdecode(file("./security_Group_list.csv"))
}

module "SecurityGroupRule" {
    source            = "../00-Module/SecurityGroupRule"
    sgrs              = local.security_group_list 
    scg_ids           = local.scg_ids
}

###############  import method
# module "SecurityGroupRule" {
#     source          = "../00-Module/SecurityGroupRule"
#     # SecurityGroup Rule 
#     # Resource creation method : for_each
#     # key   : rule
#     # rule  : {SecurityGroup_identifier}_{type}_{from_port}_{to_port}_{protocol} / split{"_",rule}
#     sgrs = [
#         {
#             security_group_identifier   = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "bestion")]
#             rule                        = "bestion_ingress_10022_10022_tcp_0.0.0.0/0"
#             rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
#             description                 = "SSH"
#         },
#         {
#             security_group_identifier   = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "bestion")]
#             rule                        = "bestion_ingress_3128_3128_tcp_wproxy"
#             rule_target                 = merge(local.sgrs_target, { source_security_group_id = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "web")] })
#             description                 = "SSH"
#         },
#         {
#             security_group_identifier   = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "xalb")]
#             rule                        = "xalb_ingress_80_80_tcp_0.0.0.0/0"
#             rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
#             description                 = "Web Service"
#         },
#         {
#             security_group_identifier   = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "web")]
#             rule                        = "web_ingress_10022_10022_tcp_bestion"
#             rule_target                 = merge(local.sgrs_target, { source_security_group_id = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "bestion")]} )
#             description                 = "from Bestion SSH"
#         },
#         {
#             security_group_identifier   = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "web")]
#             rule                        = "web_ingress_80_80_tcp_bestion"
#             rule_target                 = merge(local.sgrs_target, { source_security_group_id = local.scg_ids[format("${local.tags["sgs"].Name}-%s", "xalb")]} )
#             description                 = "from xalb Web Service"
#         }
#     ]
# }