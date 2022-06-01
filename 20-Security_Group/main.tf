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
    }
    vpc_id       = data.terraform_remote_state.VPC_Subnet.outputs.vpc_id
}

module "create-security_group" {
    source          = "../00-Module/SecurityGroup"
    sgs             = [
        {
            identifier       = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))
            vpc_id           = local.vpc_id["${lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"]
            tags                = merge( local.tags["sgs"],
                {
                    "Name" = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))
                }
            )
        },
        {
            identifier       = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            vpc_id           = local.vpc_id["${lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"]
            tags                = merge( local.tags["sgs"],
                {
                    "Name" = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
                }
            )
        },
        {
            identifier       = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "xalb"))
            vpc_id           = local.vpc_id["${lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"]
            tags                = merge( local.tags["sgs"],
                {
                    "Name" = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "xalb"))
                }
            )
        }
    ]
    
    # SecurityGroup Rule 
    # rule = "{type}_{from_port}_{to_port}_{protocol}""
    sgrs = [
        {
            security_group_identifier   = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "bestion"))
            rule                        = "egress_0_0_-1"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "outbound ANY"
        },
        {
            security_group_identifier   = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "xalb"))
            rule                        = "egress_0_0_-1"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "outbound ANY"
        },
        {
            security_group_identifier   = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            rule                        = "egress_0_0_-1"
            rule_target                 = merge(local.sgrs_target, { cidr_blocks = ["0.0.0.0/0"] })
            description                 = "outbound ANY"
        }
    ]
}
# SecurityGroup rule object key 
# cidr_block : "{Security_group_identifier}_{rule_type}_{from_port}_{to_port}_{cidr_block}"
# source_security_group_id : "{Security_group_identifier}_{rule_type}_{from_port}_{to_port}_{source_security_group_id}"
