# 10-VPC_Subnet Description
# Create AWS Resource List VPC, Insternet Gateway, Subnet, NAT Gateway, Elastic IP(NAT Gateway)


# Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
locals {
    project_code = "tra01"
    Region       = "an2"
    Environment  = "DEV"
    # Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
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
        "rt"   = {
            "Name"  = lower(format("rt-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "scg"     = {
            "Name"  = lower(format("scg-an2-%s-%s", local.project_code, local.Environment))
            "ENV"   = "${local.Environment}"
        }
        "ec2"   = {
            "Name"  = lower(format("ec2-an2-%s-%s", local.project_code, local.Environment))
        }
        "tg"   = {
            "Name"  = lower(format("tg-an2-%s-%s", local.project_code, local.Environment))
        }
    }
}