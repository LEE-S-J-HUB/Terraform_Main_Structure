locals {
    rtrs_target_resouce_id = {
        gateway_id          = null
        nat_gateway_id      = null
    }
    tags     = data.terraform_remote_state.local.outputs.global_environment_tags
    igw_list = data.terraform_remote_state.VPC_Subnet.outputs.igw_ids
    ngw_list = data.terraform_remote_state.VPC_Subnet.outputs.ngw_ids
    vpc_list = data.terraform_remote_state.VPC_Subnet.outputs.vpc_ids
    sub_list = data.terraform_remote_state.VPC_Subnet.outputs.sub_ids
}    
    
module "RouteTable" {
    source  = "../00-Module/RouteTable/"
    providers = {
        aws = aws.test
    }
    # rts Description : Create Resource - route_table
    # rt_Key : rt_identifier ( rt_tags["Name"])
    # igw_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    
    rt      = [
        {
            rt_identifier       = format("${local.tags["rt"].Name}-%s", "lb")
            vpc_id              = local.vpc_list["vpc-an2-tra01-dev-pub"]
            tags                = merge( local.tags["rt"], { "Name" = format("${local.tags["rt"].Name}-%s", "lb") } )
        },
        {
            rt_identifier       = format("${local.tags["rt"].Name}-%s", "web")
            vpc_id              = local.vpc_list["vpc-an2-tra01-dev-pub"]
            tags                = merge( local.tags["rt"], { "Name" = format("${local.tags["rt"].Name}-%s", "web") } )
        }
    ]
    # rts Description : Create Resource - route_table_association
    # rta_Key : association_subent_id
    rta     = [
        {
            rt_identifier           = format("${local.tags["rt"].Name}-%s", "lb")
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-lb-01a"]
        },
        {
            rt_identifier           = format("${local.tags["rt"].Name}-%s", "lb")
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-lb-01c"]
        },
        {
            rt_identifier           = format("${local.tags["rt"].Name}-%s", "web")
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-web-01a"]
        },
        {
            rt_identifier           = format("${local.tags["rt"].Name}-%s", "web")
            association_subent_id   = local.sub_list["sub-an2-tra01-dev-web-01c"]
        }
    ]
    # rtrs Description : Create Resource - route(Routing)
    # Non for_each(count setting)
    # target_resource = merge(local.rtrs_target_resouce_id, route target id)
    rtr     = [
        {
            route_table_identifier  = format("${local.tags["rt"].Name}-%s", "lb")
            destination_cidr_block  = "0.0.0.0/0"
            target_resource         = merge(local.rtrs_target_resouce_id,
                { gateway_id = local.igw_list["${format("${local.tags["igw"].Name}-%s", "pub")}"] }
            )
        },
        {
            route_table_identifier  = format("${local.tags["rt"].Name}-%s", "web")
            destination_cidr_block  = "0.0.0.0/0"
            target_resource         = merge(local.rtrs_target_resouce_id,
                { gateway_id = local.ngw_list["${format("${local.tags["ngw"].Name}-%s", "lb-01a")}"] }
            )
        }
    ]
}