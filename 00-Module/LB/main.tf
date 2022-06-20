resource "aws_lb" "alb" {
    for_each                    = { for alb in var.alb : alb.name => alb    }
    name                        = lookup(each.value, "name", null)
    internal                    = each.value.internal
    load_balancer_type          = "application"
    security_groups             = each.value.security_groups
    subnets                     = each.value.subnets
    enable_deletion_protection  = each.value.enable_deletion_protection
}

resource "aws_lb" "nlb" {
    for_each                    = { for nlb in var.nlb : nlb.name => nlb    }
    name                        = lookup(each.value, "name", null)
    internal                    = each.value.internal
    load_balancer_type          = "network"
    subnets                     = each.value.subnets
    enable_deletion_protection  = each.value.enable_deletion_protection
}