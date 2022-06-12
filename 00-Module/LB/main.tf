resource "aws_lb" "this" {
    for_each                    = { for alb in var.albs : alb.name => alb    }
    name                        = lookup(each.value, "name", null)
    internal                    = each.value.internal
    load_balancer_type          = "application"
    security_groups             = each.value.security_groups
    subnets                     = each.value.subnets
    enable_deletion_protection  = each.value.enable_deletion_protection
}
