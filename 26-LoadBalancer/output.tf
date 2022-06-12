# # output "ec2_instaces_id" {
# #     value = {for k,ec2 in module.create-ec2_instance.ec2_instance : k => ec2.id }
# # }

# # output "ec2_instaces_public_ip" {
# #     value = {for k,ip in module.create-ec2_instance.ec2_instance : k => ip.public_ip }
# # }

# # output "ec2_instaces_private_ip" {
# #     value = {for k,ip in module.create-ec2_instance.ec2_instance : k => ip.private_ip }
# # }

# output "TargetGroup" {
#     value  = aws_lb_target_group.ip-example
# }

# output "target_group_arn" {
#     value  = aws_lb_target_group.ip-example.arn
# }

# output "target_group_attachment" {
#     value   = aws_lb_target_group_attachment.test
# }

# output "aws_lb" {
#     value = module.aws_lb.
# }