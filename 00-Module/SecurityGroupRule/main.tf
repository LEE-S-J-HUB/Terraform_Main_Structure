resource "aws_security_group_rule" "sgr_cidr_blocks" {
    for_each                    = {for sgr in var.sgrs : "${sgr.SecurityGroup}_${sgr.PortRange}_${sgr.Source}" => sgr if can(regex("[0-9]+.[0-9]+.[0-9]+.[0-9]+/[0-9]+", sgr.Source)) == true } 
    # provider                    = aws."${each.value.AccountName}"
    security_group_id           = var.scg_ids[each.value.SecurityGroup]
    type                        = each.value.Type
    from_port                   = split("-", each.value.PortRange)[0]
    to_port                     = can(split("-", each.value.PortRange)[1]) ? split("-", each.value.PortRange)[1] : split("-", each.value.PortRange)[0]
    protocol                    = each.value.Protocol
    cidr_blocks                 = [each.value.Source]
    description                 = each.value.Description
    source_security_group_id    = null
    ipv6_cidr_blocks            = null
    prefix_list_ids             = null
}

resource "aws_security_group_rule" "sgr_source_security_group_id" {
    for_each                    = {for sgr in var.sgrs : "${sgr.SecurityGroup}_${sgr.PortRange}_${sgr.Source}" => sgr if can(regex("[0-9a-zA-Z]+-[0-9a-zA-Z]+-[0-9a-zA-Z]+-[0-9a-zA-Z]+-[0-9a-zA-Z]+", sgr.Source)) == true } 
    # provider                    = format("aws.%s", each.value.AccountName) 
    security_group_id           = var.scg_ids[each.value.SecurityGroup]
    type                        = each.value.Type
    from_port                   = split("-", each.value.PortRange)[0]
    to_port                     = can(split("-", each.value.PortRange)[1]) ? split("-", each.value.PortRange)[1] : split("-", each.value.PortRange)[0]
    protocol                    = each.value.Protocol
    source_security_group_id    = var.scg_ids[each.value.Source]
    description                 = each.value.Description
    cidr_blocks                 = null
    ipv6_cidr_blocks            = null
    prefix_list_ids             = null
}

# resource "aws_security_group_rule" "this" {
    #### resource creation method : count (운영과정에 문제가 보임)
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
    #### resource creation method : for_each
    # for_each                    = {for sgr in var.sgrs : sgr.rule => sgr}
    # security_group_id           = lookup(each.value, "security_group_identifier", null)
    # type                        = split("_", each.value.rule)[1]
    # from_port                   = split("_", each.value.rule)[2]
    # to_port                     = split("_", each.value.rule)[3]
    # protocol                    = split("_", each.value.rule)[4]
    # cidr_blocks                 = lookup(each.value.rule_target, "cidr_blocks", null)
    # ipv6_cidr_blocks            = lookup(each.value.rule_target, "ipv6_cidr_blocks", null)
    # prefix_list_ids             = lookup(each.value.rule_target, "prefix_list_ids", null)
    # source_security_group_id    = lookup(each.value.rule_target, "source_security_group_id", null)
    # description                 = lookup(each.value, "description", null)
# }
