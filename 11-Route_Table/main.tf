locals {
    project_code = "tra01"
    Environment  = "DEV"
    tags         = {
        "rts"   = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
    }
    rtrs_target_resouce_id = {
        gateway_id          = null
        nat_gateway_id      = null
    }
    igw_list = data.terraform_remote_state.VPC_Subnet.outputs.igw_id
    ngw_list = data.terraform_remote_state.VPC_Subnet.outputs.ngw_id
}    
    
module "RouteTable" {
    source  = "../00-Module/RouteTable/"
    # rts Description : Create Resource - route_table
    # rt_Key : rt_identifier ( rt_tags["Name"])
    # igw_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    rts     = [
        {
            rt_identifier       = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
            vpc_id              = "${data.terraform_remote_state.VPC_Subnet.outputs.vpc_id["vpc-an2-tra01-dev-pub"]}"
            tags                = merge( local.tags["rts"],
                {
                    "Name" = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
                }
            )
        },
        {
            rt_identifier       = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            vpc_id              = "${data.terraform_remote_state.VPC_Subnet.outputs.vpc_id["vpc-an2-tra01-dev-pub"]}"
            tags                = merge( local.tags["rts"],
                {
                    "Name" = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
                }
            )
        }
    ]
    # rts Description : Create Resource - route_table_association
    # rta_Key : association_subent_id
    rtas    = [
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
            association_subent_id   = "${data.terraform_remote_state.VPC_Subnet.outputs.subnet_id["sub-an2-tra01-dev-lb-01a"]}"
        },
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
            association_subent_id   = "${data.terraform_remote_state.VPC_Subnet.outputs.subnet_id["sub-an2-tra01-dev-lb-01c"]}"
        },
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            association_subent_id   = "${data.terraform_remote_state.VPC_Subnet.outputs.subnet_id["sub-an2-tra01-dev-web-01a"]}"
        },
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            association_subent_id   = "${data.terraform_remote_state.VPC_Subnet.outputs.subnet_id["sub-an2-tra01-dev-web-01c"]}"
        }
    ]
    # rtrs Description : Create Resource - route(Routing)
    # Non for_each(count setting)
    # target_resource = merge(local.rtrs_target_resouce_id, route target id)
    rtrs    = [
        {
            route_table_identifier  = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
            destination_cidr_block  = "0.0.0.0/0"
            target_resource         = merge(local.rtrs_target_resouce_id,
                { gateway_id = local.igw_list["${lower(format("igw-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"] }
            )
        }
    ]
}