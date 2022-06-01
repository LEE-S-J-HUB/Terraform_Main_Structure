resource "aws_route_table" "this" {
    for_each            = { for rt in var.rts : rt.rt_identifier => rt}
    vpc_id              = each.value.vpc_id
    tags                = each.value.tags
}

resource "aws_route_table_association" "this" {
    for_each        = { for rta in var.rtas : rta.association_subent_id  => rta }
    route_table_id  = aws_route_table.this["${each.value.rt_identifier}"].id
    subnet_id   = each.value.association_subent_id
}


resource "aws_route" "this" {
    
    # for_each                = { for rtr in var.rtrs : rtr.rtr_identifier  => rtr }
    # route_table_id          = aws_route_table.this[each.value.route_table_identifier].id
    # destination_cidr_block  = lookup(each.value, "destination_cidr_block", null)
    # gateway_id              = lookup(each.value, "gateway_id", null)
    # nat_gateway_id          = lookup(each.value, "nat_gateway_id", null)
    count                     = length(var.rtrs)
    route_table_id            = aws_route_table.this["${element(var.rtrs, count.index).route_table_identifier}"].id
    destination_cidr_block    = lookup(element(var.rtrs, count.index), "destination_cidr_block", null)
    gateway_id                = lookup(element(var.rtrs, count.index).target_resource, "gateway_id", null)
    nat_gateway_id            = lookup(element(var.rtrs, count.index).target_resource, "nat_gateway_id", null)
}