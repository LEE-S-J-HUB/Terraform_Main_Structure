locals {
    project_code            = "tra01"
    Environment             = "DEV"
    tags                    = {
        "TargetGroup"   = {
            "Name"  = lower(format("tg-an2-%s-%s", local.project_code, local.Environment))
        }
        "vpc"   = {
            "Name"  = lower(format("vpc-an2-%s-%s", local.project_code, local.Environment))
        }
        "ec2"   = {
            "Name"  = lower(format("ec2-an2-%s-%s", local.project_code, local.Environment))
        }
    }
    vpc_ids         = data.terraform_remote_state.VPC_Subnet.outputs.vpc_ids
    ec2_ids         = data.terraform_remote_state.EC2.outputs.ec2_instaces_ids
}

module "lb_TargetGroup" {
    source = "../00-Module/lb_TargetGroup"
    # resource : aws_lb_target_group
    # resource creation method : for_each
    # key : name
    tgs     = [
        {
            name                    = format("${local.tags["TargetGroup"].Name}-%s", "web")
            port                    = 80
            protocol                = "HTTP"
            target_type             = "instance"
            vpc_id                  = local.vpc_ids["${format("${local.tags["vpc"].Name}-%s", "pub")}"]
        }
    ]

    # resource : aws_lb_target_group_attachment
    # resource creation method : for_each
    # key : {target_group_identifier}_{target_id}_{port}
    tgas    = [
        {
            target_group_identifier = format("${local.tags["TargetGroup"].Name}-%s", "web")
            target_id               = local.ec2_ids[format("${local.tags["ec2"].Name}-%s", "web")]
            port                    = 80
        }
    ]
}