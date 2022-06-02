output "SecurityGroup" {
    value = aws_security_group.this
}


output "scg_ids" {
    value = { for k,scg in aws_security_group.this : k => scg.id }
}