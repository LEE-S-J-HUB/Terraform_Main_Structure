locals {
    project_code            = "tra01"
    Environment             = "DEV"
    tags                    = {
        "alb"   = {
            "Name"  = lower(format("alb-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "nlb"   = {
            "Name"  = lower(format("nlb-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
    }
    scg_list  = data.terraform_remote_state.SecurityGroup.outputs.scg_ids
    sub_list  = data.terraform_remote_state.VPC_Subnet.outputs.sub_ids
}

module "aws_lb" {
    source  = "../00-Module/LB/"
    alb = [
        {
            name                        = format("${local.tags["alb"].Name}-%s", "web")
            internal                    = false
            security_groups             = [local.scg_list["scg-an2-tra01-dev-xalb"]]
            subnets                     = [local.sub_list["sub-an2-tra01-dev-lb-01a"], local.sub_list["sub-an2-tra01-dev-lb-01c"]]
            enable_deletion_protection  = false
            tags = merge(local.tags["alb"], { "Name" = format("${local.tags["alb"].Name}-%s", "web") } )
        }
    ]
    nlb = [
        {
            name                        = format("${local.tags["nlb"].Name}-%s", "web")
            internal                    = false
            subnets                     = [local.sub_list["sub-an2-tra01-dev-lb-01a"], local.sub_list["sub-an2-tra01-dev-lb-01c"]]
            enable_deletion_protection  = false
            tags = merge(local.tags["alb"], { "Name" = format("${local.tags["nlb"].Name}-%s", "web") } )
        }
    ]
}