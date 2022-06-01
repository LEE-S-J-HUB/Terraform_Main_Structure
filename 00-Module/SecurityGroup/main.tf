resource "aws_security_group" "this" {
    for_each            = { for sg in var.sgs : sg.identifier => sg }
    vpc_id              = each.value.vpc_id
    name                = each.value.tags["Name"]
    tags                = each.value.tags
}

resource "aws_security_group_rule" "security_group_rule_cidr_blocks" {
    count                       = length(var.sgrs)
    security_group_id           = aws_security_group.this["${element(var.sgrs, count.index).security_group_identifier}"].id
    type                        = split("_", element(var.sgrs, count.index).rule)[0]
    from_port                   = split("_", element(var.sgrs, count.index).rule)[1]
    to_port                     = split("_", element(var.sgrs, count.index).rule)[2]
    protocol                    = split("_", element(var.sgrs, count.index).rule)[3]
    cidr_blocks                 = lookup(element(var.sgrs, count.index).rule_target, "cidr_blocks", [null])
    ipv6_cidr_blocks            = lookup(element(var.sgrs, count.index).rule_target, "ipv6_cidr_blocks", [null])
    prefix_list_ids             = lookup(element(var.sgrs, count.index).rule_target, "prefix_list_ids", [null])
    description                 = element(var.sgrs, count.index).description
}