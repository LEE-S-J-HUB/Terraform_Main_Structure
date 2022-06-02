# 10-VPC_Subnet Description
# Create AWS Resource List VPC, Insternet Gateway, Subnet, NAT Gateway, Elastic IP(NAT Gateway)

locals {
    project_code = "tra01"
    Environment  = "DEV"
    tags         = {
        "vpc"   = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
        "igw"   = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
        "subnet"   = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
        "ngw"   = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
        "eip"   = {
            "Name"  = ""
            "ENV"   = "${local.Environment}"
        }
    }
}

module "VPC_Subnet" {
    source  = "../00-Module/VPC_Subnet/"
    # vpcs Description : Create Resource - vpc, igw
    # vpc_Key : vpc_identifier ( vpc_tags["Name"])
    # igw_Key : igw_identifier ( igw_tags["Name"])
    # vpc_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    # igw_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    vpcs    = [
        {
            vpc_identifier          = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
            cidr_block              = "192.168.230.0/24"
            enable_dns_hostnames    = true
            enable_dns_support      = true
            instance_tenancy        = "default"
            vpc_tags                = merge( local.tags["vpc"],
                {
                    "Name" = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
                }
            )
            attach_igw              = true
            igw_identifier          = lower(format("igw-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
            igw_tags                = merge( local.tags["igw"],
                {
                    "Name" = lower(format("igw-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
                }
            )
        },
        {
            vpc_identifier          = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "Pri"))
            cidr_block              = "192.168.240.0/24"
            enable_dns_hostnames    = true
            enable_dns_support      = true
            instance_tenancy        = "default"
            vpc_tags                = merge( local.tags["vpc"],
                {
                    "Name" = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "Pri"))
                }
            )
            attach_igw              = false
            igw_identifier          = null
            igw_tags                = null
        }
    ]

    # subnets Description : Create Resource - subnet, ngw(ngw-eip)
    # subnet_Key : vpc_identifier ( subnet_tags["Name"])
    # ngw_Key : igw_identifier ( igw_tags["Name"])
    # eip_Key : eip_identifier ( igw_tags["Name"])
    # subnet_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    # ngw_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    # eip_tags["Name"] Format : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    subnets = [
        {
            subnet_identifier       = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01a"))
            vpc_identifier          = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
            availability_zone       = "ap-northeast-2a"
            cidr_block              = "192.168.230.0/27"
            subnet_tags             = merge( local.tags["subnet"],
                {
                    "Name" = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01a"))
                }
            )
            # attach_ngw              = true
            # ngw_identifier          = lower(format("ngw-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01a"))
            # eip_identifier          = lower(format("eip-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01a"))
            # ngw_tags                = merge( local.tags["ngw"],
            #     {
            #         "Name" = lower(format("ngw-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01a"))
            #     }
            # )
            # eip_tags                = merge( local.tags["eip"],
            #     {
            #         "Name" = lower(format("eip-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01a"))
            #     }
            attach_ngw              = null
            ngw_identifier          = null
            eip_identifier          = null
            ngw_tags                = null
            eip_tags                = null         
        },
        {
            subnet_identifier       = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01c"))
            vpc_identifier          = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
            availability_zone       = "ap-northeast-2c"
            cidr_block              = "192.168.230.32/27"
            subnet_tags             = merge( local.tags["subnet"],
                {
                    "Name" = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "lb-01c"))
                }
            )
            attach_ngw              = null
            ngw_identifier          = null
            eip_identifier          = null
            ngw_tags                = null
            eip_tags                = null
        },
                {
            subnet_identifier       = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "web-01a"))
            vpc_identifier          = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
            availability_zone       = "ap-northeast-2a"
            cidr_block              = "192.168.230.64/27"
            subnet_tags             = merge( local.tags["subnet"],
                {
                    "Name" = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "web-01a"))
                }
            )
            attach_ngw              = null
            ngw_identifier          = null
            eip_identifier          = null
            ngw_tags                = null
            eip_tags                = null            
        },
        {
            subnet_identifier       = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "web-01c"))
            vpc_identifier          = lower(format("vpc-an2-%s-%s-%s", local.project_code, local.Environment, "pub"))
            availability_zone       = "ap-northeast-2c"
            cidr_block              = "192.168.230.96/27"
            subnet_tags             = merge( local.tags["subnet"],
                {
                    "Name" = lower(format("sub-an2-%s-%s-%s", local.project_code, local.Environment, "web-01c"))
                }
            )
            attach_ngw              = null
            ngw_identifier          = null
            eip_identifier          = null
            ngw_tags                = null
            eip_tags                = null
        }
    ]
}