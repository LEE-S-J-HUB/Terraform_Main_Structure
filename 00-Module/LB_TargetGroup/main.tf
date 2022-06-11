resource "aws_lb_target_group" "this" {
    for_each    = { for k in var.tgs : k.name => k}
    name        = lookup(each.value, "name", null)
    port        = lookup(each.value, "port", null)
    protocol    = lookup(each.value, "protocol", null)
    target_type = lookup(each.value, "instance", null)
    vpc_id      = lookup(each.value, "vpc_id", null)
}

resource "aws_lb_target_group_attachment" "this" {
    for_each    = { for k in var.tgas : "${k.target_group_identifier}_${k.target_id}_${k.port}" => k}
    target_group_arn    = lookup(aws_lb_target_group.this[each.value.target_group_identifier], "arn", null ) 
    target_id           = lookup(each.value, "target_id", null)
    port                = lookup(each.value, "port", null)
}