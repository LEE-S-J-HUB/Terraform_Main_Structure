# 10-VPC_Subnet Description
# Create AWS Resource List VPC, Insternet Gateway, Subnet, NAT Gateway, Elastic IP(NAT Gateway)


# Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
locals {
    project_code = "tra01"
    Environment  = "DEV"
    tags         = {
        "vpc"   = {
            "Name"  = lower(format("vpc-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "igw"   = {
            "Name"  = lower(format("igw-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "sub"   = {
            "Name"  = lower(format("sub-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "ngw"   = {
            "Name"  = lower(format("ngw-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "eip"   = {
            "Name"  = lower(format("eip-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
    }
}

module "VPC_Subnet" {
    source  = "../00-Module/VPC_Subnet/"
    # Resource creation method : for_each
    # vpc Key : vpc_identifier ( vpc_tags["Name"])
    vpcs    = [
        {
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pub")
            cidr_block              = "192.168.230.0/24"
            enable_dns_hostnames    = true
            enable_dns_support      = true
            instance_tenancy        = "default"
            vpc_tags                = merge( local.tags["vpc"], { "Name" = format("${local.tags["vpc"].Name}-%s", "pub") } )
        },
        {
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pri")
            cidr_block              = "192.168.240.0/24"
            enable_dns_hostnames    = true
            enable_dns_support      = true
            instance_tenancy        = "default"
            vpc_tags                = merge( local.tags["igw"], { "Name" = format("${local.tags["igw"].Name}-%s", "pri") } )
        }
    ]

    # Resource creation method : for_each
    # sub Key : subnet_identifier ( subnet_tags["Name"])
    subs = [
        {
            sub_identifier          = format("${local.tags["sub"].Name}-%s", "lb-01a")
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pub")
            availability_zone       = "ap-northeast-2a"
            cidr_block              = "192.168.230.0/27"
            subnet_tags             = merge( local.tags["sub"], { "Name" = format("${local.tags["sub"].Name}-%s", "lb-01a") } ) 
        },
        {
            sub_identifier          = format("${local.tags["sub"].Name}-%s", "lb-01c")
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pub")
            availability_zone       = "ap-northeast-2c"
            cidr_block              = "192.168.230.32/27"
            subnet_tags             = merge( local.tags["sub"], { "Name" = format("${local.tags["sub"].Name}-%s", "lb-01c") } ) 
        },
                {
            sub_identifier          = format("${local.tags["sub"].Name}-%s", "web-01a")
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pub")
            availability_zone       = "ap-northeast-2a"
            cidr_block              = "192.168.230.64/27"
            subnet_tags             = merge( local.tags["sub"], { "Name" = format("${local.tags["sub"].Name}-%s", "web-01a") } )      
        },
        {
            sub_identifier          = format("${local.tags["sub"].Name}-%s", "web-01c")
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pub")
            availability_zone       = "ap-northeast-2c"
            cidr_block              = "192.168.230.96/27"
            subnet_tags             = merge( local.tags["sub"], { "Name" = format("${local.tags["sub"].Name}-%s", "web-01c") } )  
        }
    ]

    # Resource creation method : for_each
    # igw Key : igw_identifier ( igw_tags["Name"])
    igws    = [
        {
            vpc_identifier          = format("${local.tags["vpc"].Name}-%s", "pub")
            igw_identifier          = format("${local.tags["igw"].Name}-%s", "pub")
            igw_tags                = merge( local.tags["igw"], { "Name" = format("${local.tags["igw"].Name}-%s", "pub") } )
        }
    ]

    # Resource creation method : for_each
    # ngw Key : ngw_identifier ( ngw_tags["Name"])
    # eip Key : eip_identifier ( eip_tags["Name"])
    ngws    = [
        {
            # sub_identifier          = format("${local.tags["sub"].Name}-%s", "lb-01a")
            # ngw_identifier          = format("${local.tags["ngw"].Name}-%s", "lb-01a")
            # eip_identifier          = format("${local.tags["eip"].Name}-%s", "ngw")
            # ngw_tags                = merge( local.tags["ngw"], { "Name" = format("${local.tags["ngw"].Name}-%s", "lb-01a") } )
            # eip_tags                = merge( local.tags["eip"], { "Name" = format("${local.tags["eip"].Name}-%s", "ngw") } )
            sub_identifier          = null
            ngw_identifier          = null
            eip_identifier          = null
            ngw_tags                = null
            eip_tags                = null
        }
    ]
}