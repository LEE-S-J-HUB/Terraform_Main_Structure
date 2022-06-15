output "aws_security_group_rule_cidr" {
    value       = aws_security_group_rule.sgr_cidr_blocks
}

output "aws_security_group_rule_source_security_group" {
    value       = aws_security_group_rule.sgr_source_security_group_id
}
