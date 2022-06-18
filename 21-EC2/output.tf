output "ec2_instaces_ids" {
    value = {for k,ec2 in module.create-ec2_instance.ec2_instance : k => ec2.id }
}

output "ec2_instaces_public_ip" {
    value = {for k,ip in module.create-ec2_instance.ec2_instance : k => ip.public_ip }
}

output "ec2_instaces_private_ip" {
    value = {for k,ip in module.create-ec2_instance.ec2_instance : k => ip.private_ip }
}

output "ec2_eip" {
    value = {for k,ip in module.create-ec2_instance.eip : k => "${ip.public_ip}-${ip.private_ip}"}
}