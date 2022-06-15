output "scg_ids" {
    value = { for k,scg in module.SecurityGroup.SecurityGroup : k => scg.id }
}

# output "security_group_rule_cidr_blocks" {
#     value = { for k,sgp in module.create-security_group.security_group_rule_cidr_blocks : k => sgp.id if sgp.cidr_blocks != null}
# }

# output "security_group_rule_source_security_group_id" {
#     value = { for k,sgp in module.create-security_group.security_group_rule_source_security_group_id : k => sgp.id if sgp.cidr_blocks != null}
# }


output "aws_security_group_rule_cidr" {

    value       = { for k, value in module.SecurityGroupRule.aws_security_group_rule_cidr : k => value.type}
}

output "aws_security_group_rule_source_security_group" {
    value       = { for k, value in module.SecurityGroupRule.aws_security_group_rule_source_security_group : k => value.type}
}
