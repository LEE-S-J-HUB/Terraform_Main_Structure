output "vpc" {
    value = aws_vpc.this
}

output "igw" {
    value = aws_internet_gateway.this
}

output "sub" {
    value = aws_subnet.this
}

output "ngw" {
    value = aws_nat_gateway.this
}

output "ngw_eip" {
    value = aws_eip.this 
}