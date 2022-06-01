output "vpc_id" {
    value = { for k,vpc in module.VPC_Subnet.vpc : k => vpc.id }
}

output "igw_id" {
    value = { for k,igw in module.VPC_Subnet.internet_gateway : k =>igw.id }
}

output "subnet_id" {
    value = { for k,sub in module.VPC_Subnet.subnet : k => sub.id }
}

output "ngw_id" {
    value = { for k,ngw in module.VPC_Subnet.nat_gateway : k => ngw.id }
}

output "nat_eip_id" {
    value = { for k,eip in module.VPC_Subnet.nat_eip : k => eip.id }
}