output "aws_lb_target_group" {
    value = module.lb_TargetGroup.aws_lb_target_group
}

output "aws_lb_target_group_arn" {
    value = { for arn, k in module.lb_TargetGroup.aws_lb_target_group : arn => k.arn }
}

output "aws_lb_target_group_attachment" {
    value = module.lb_TargetGroup.aws_lb_target_group_attachment
}