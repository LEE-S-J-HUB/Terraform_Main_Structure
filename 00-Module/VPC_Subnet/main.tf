resource "aws_vpc" "this" {
    for_each                = { for vpc in var.vpcs : vpc.vpc_identifier => vpc }
    cidr_block              = each.value.cidr_block
    enable_dns_hostnames    = each.value.enable_dns_hostnames
    enable_dns_support      = each.value.enable_dns_support
    instance_tenancy        = each.value.instance_tenancy
    tags                    = each.value.vpc_tags
}

resource "aws_internet_gateway" "this" {
    for_each                = { for igw in var.igws : igw.igw_identifier => igw }
	vpc_id                  = aws_vpc.this["${each.value.vpc_identifier}"].id
    tags                    = each.value.igw_tags
}

resource "aws_subnet" "this" {
    for_each            = { for sub in var.subs : sub.sub_identifier => sub }
    vpc_id              = aws_vpc.this["${each.value.vpc_identifier}"].id
    availability_zone   = each.value.availability_zone
    cidr_block          = each.value.cidr_block
    tags                = each.value.subnet_tags
}

resource "aws_eip" "this" {
    for_each            = { for eip in var.ngws : eip.eip_identifier => eip if eip.eip_identifier != null }
    vpc                 = true
    tags                = each.value.eip_tags
}

resource "aws_nat_gateway" "this" {
    for_each            = { for ngw in var.ngws : ngw.ngw_identifier => ngw if ngw.eip_identifier != null }
    subnet_id           = aws_subnet.this["${each.value.sub_identifier}"].id
    allocation_id       = aws_eip.this["${each.value.eip_identifier}"].id
    tags                = each.value.ngw_tags
}
