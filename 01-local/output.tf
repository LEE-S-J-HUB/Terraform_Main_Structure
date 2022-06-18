# output "vpc_ids" {
#     value = { for k,vpc in module.VPC_Subnet.vpc : k => vpc.id }
# }

# output "igw_ids" {
#     value = { for k,igw in module.VPC_Subnet.igw : k =>igw.id }
# }

# output "sub_ids" {
#     value = { for k,sub in module.VPC_Subnet.sub : k => sub.id }
# }

# output "ngw_ids" {
#     value = { for k,ngw in module.VPC_Subnet.ngw : k => ngw.id }
# }

# output "ngw_eip_ids" {
#     value = { for k,eip in module.VPC_Subnet.ngw_eip : k => eip.id }
# }

output "global_environment_tags" {
    value   = local.tags
}

