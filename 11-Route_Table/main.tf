locals {
    project_code = "tra01"
    Environment  = "DEV"
    tags         = {
        "rts"   = {
            "Name"  = lower(format("rt-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
    }
    rtrs_target_resouce_id = {
        gateway_id          = null
        nat_gateway_id      = null
    }
    igw_list = data.terraform_remote_state.VPC_Subnet.outputs.igw_ids
    ngw_list = data.terraform_remote_state.VPC_Subnet.outputs.ngw_ids
    vpc_list = data.terraform_remote_state.VPC_Subnet.outputs.vpc_ids
    sub_list = data.terraform_remote_state.VPC_Subnet.outputs.sub_ids
}    
    
module "RouteTable" {
    source  = "../00-Module/RouteTable/"
    # rts Description : Create Resource - route_table
    # rt_Key : rt_identifier ( rt_tags["Name"])
    # igw_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    rts     = [
        {
            rt_identifier       = format("${local.tags["rts"].Name}-%s", "lb")
            vpc_id              = local.vpc_list["vpc-an2-tra01-dev-pub"]
            tags                = merge( local.tags["rts"],
                {
                    "Name" = format("${local.tags["rts"].Name}-%s", "lb")
                }
            )
        },
        {
            rt_identifier       = format("${local.tags["rts"].Name}-%s", "web")
            vpc_id              = local.vpc_list["vpc-an2-tra01-dev-pub"]
            tags                = merge( local.tags["rts"],
                {
                    "Name" = format("${local.tags["rts"].Name}-%s", "web")
                }
            )
        }
    ]
    # rts Description : Create Resource - route_table_association
    # rta_Key : association_subent_id
    rtas    = [
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-lb-01a"]
        },
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "lb"))
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-lb-01c"]
        },
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-web-01a"]
        },
        {
            rt_identifier           = lower(format("rt-an2-%s-%s-%s", local.project_code, local.Environment, "web"))
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-web-01c"]
        }
    ]
    # rtrs Description : Create Resource - route(Routing)
    # Non for_each(count setting)
    # target_resource = merge(local.rtrs_target_resouce_id, route target id)
    rtrs    = [
        {
            route_table_identifier  = format("${local.tags["rts"].Name}-%s", "lb")
            destination_cidr_block  = "0.0.0.0/0"
            target_resource         = merge(local.rtrs_target_resouce_id,
                { gateway_id = local.igw_list["${lower(format("igw-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))}"] }
            )
        }
    ]
}