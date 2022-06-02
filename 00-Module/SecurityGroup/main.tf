resource "aws_security_group" "this" {
    for_each            = { for sg in var.sgs : sg.identifier => sg }
    vpc_id              = each.value.vpc_id
    name                = each.value.tags["Name"]
    tags                = each.value.tags
}