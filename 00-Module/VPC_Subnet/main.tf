resource "aws_vpc" "this" {
    for_each                = { for vpc in var.vpcs : vpc.vpc_identifier => vpc }
    cidr_block              = each.value.cidr_block
    enable_dns_hostnames    = each.value.enable_dns_hostnames
    enable_dns_support      = each.value.enable_dns_support
    instance_tenancy        = each.value.instance_tenancy
    tags                    = each.value.vpc_tags
}

resource "aws_internet_gateway" "this" {
    for_each                = { for vpc in var.vpcs : vpc.igw_identifier => vpc if vpc.attach_igw == true  }
	vpc_id                  = aws_vpc.this["${each.value.vpc_identifier}"].id
    tags                    = each.value.igw_tags
}

resource "aws_subnet" "this" {
    for_each            = { for subnet in var.subnets : subnet.subnet_identifier => subnet}
    vpc_id              = aws_vpc.this["${each.value.vpc_identifier}"].id
    availability_zone   = each.value.availability_zone
    cidr_block          = each.value.cidr_block
    tags                = each.value.subnet_tags
}

resource "aws_eip" "this" {
    for_each            = { for eip in var.subnets : eip.eip_identifier => eip if eip.attach_ngw == true }
    vpc                 = true
    tags                = each.value.eip_tags
}

resource "aws_nat_gateway" "this" {
    for_each            = { for ngw in var.subnets : ngw.ngw_identifier => ngw if ngw.attach_ngw == true }
    subnet_id           = aws_subnet.this["${each.value.subnet_identifier}"].id
    allocation_id       = aws_eip.this["${each.value.eip_identifier}"].id
    tags                = each.value.ngw_tags
}
