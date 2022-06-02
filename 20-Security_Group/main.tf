locals {
    project_code = "tra01"
    Environment  = "DEV"
    tags         = {
        "sgs"     = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
    }
    sgrs_target = {
        cidr_blocks                     = null
        ipv6_cidr_blocks                = null
        prefix_list_ids                 = null
        source_security_group_id        = null
    }
    vpc_id       = data.terraform_remote_state.VPC_Subnet.outputs.vpc_id
}

module "SecurityGroup" {
    source          = "../00-Module/SecurityGroup"
    sgs             = [
        {
            identifier       = lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))
            vpc_id           = local.vpc_id["${lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"]
            tags                = merge( local.tags["sgs"],
                {
                    "Name" = lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))
                }
            )
        },
        {
            identifier       = lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            vpc_id           = local.vpc_id["${lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"]
            tags                = merge( local.tags["sgs"],
                {
                    "Name" = lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
                }
            )
        },
        {
            identifier       = lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "xalb"))
            vpc_id           = local.vpc_id["${lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"]
            tags                = merge( local.tags["sgs"],
                {
                    "Name" = lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "xalb"))
                }
            )
        }
    ]
}

locals{
    scg_ids = module.SecurityGroup.scg_ids
}
module "SecurityGroupRule" {
    source          = "../00-Module/SecurityGroupRule"
    # SecurityGroup Rule 
    # Resource creation method : for_each
    # key   : rule
    # rule  : {SecurityGroup_identifier}_{type}_{from_port}_{to_port}_{protocol} / split{"_",rule}
    sgrs = [
        {
            security_group_identifier   = local.scg_ids["${lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))}"]
            rule                        = "bestion_egress_0_0_-1_0.0.0.0/0"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "outbound ANY"
        },
        {
            security_group_identifier   = local.scg_ids["${lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))}"]
            rule                        = "bestion_ingress_10022_10022_tcp_0.0.0.0/0"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "SSH"
        },
        {
            security_group_identifier   = local.scg_ids["${lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "xalb"))}"]
            rule                        = "xalb_egress_0_0_-1_0.0.0.0/0"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "outbound ANY"
        },
        {
            security_group_identifier   = local.scg_ids["${lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "web"))}"]
            rule                        = "web_egress_0_0_-1_0.0.0.0/0"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "outbound ANY"
        },
        {
            security_group_identifier   = local.scg_ids["${lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "web"))}"]
            rule                        = "web_ingress_10022_10022_-1_bestion"
            rule_target                 = merge(local.sgrs_target, { source_security_group_id = ["${local.scg_ids["${lower(format("scg-an2-%s-%s-%s", local.project_code, local.Environment, "web"))}"]}"] })
            description                 = "outbound ANY"
        }
    ]
}
