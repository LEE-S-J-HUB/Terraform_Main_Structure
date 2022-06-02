
resource "aws_security_group_rule" "this" {
    # count                       = length(var.sgrs)
    # security_group_id           = aws_security_group.this["${element(var.sgrs, count.index).security_group_identifier}"].id
    # type                        = split("_", element(var.sgrs, count.index).rule)[0]
    # from_port                   = split("_", element(var.sgrs, count.index).rule)[1]
    # to_port                     = split("_", element(var.sgrs, count.index).rule)[2]
    # protocol                    = split("_", element(var.sgrs, count.index).rule)[3]
    # cidr_blocks                 = lookup(element(var.sgrs, count.index).rule_target, "cidr_blocks", [null])
    # ipv6_cidr_blocks            = lookup(element(var.sgrs, count.index).rule_target, "ipv6_cidr_blocks", [null])
    # prefix_list_ids             = lookup(element(var.sgrs, count.index).rule_target, "prefix_list_ids", [null])
    # description                 = element(var.sgrs, count.index).description
    for_each                    = {for sgr in var.sgrs : sgr.rule => sgr}
    security_group_id           = lookup(each.value, "security_group_identifier", null)
    type                        = split("_", each.value.rule)[1]
    from_port                   = split("_", each.value.rule)[2]
    to_port                     = split("_", each.value.rule)[3]
    protocol                    = split("_", each.value.rule)[4]
    cidr_blocks                 = lookup(each.value.rule_target, "cidr_blocks", [null])
    ipv6_cidr_blocks            = lookup(each.value.rule_target, "ipv6_cidr_blocks", [null])
    prefix_list_ids             = lookup(each.value.rule_target, "prefix_list_ids", [null])
    source_security_group_id    = lookup(each.value.rule_target, "source_security_group_id", null)
    description                 = lookup(each.value, "description", null)
}


