output "ec2_instance" {
    value = aws_instance.this
}

output "eip" {
    value = aws_eip.this
}