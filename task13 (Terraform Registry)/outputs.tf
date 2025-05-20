output "instances" {
  value = [module.ec2_bastion.public_ip, module.ec2_private.public_ip]
}

output "sg_list" {
  value = [module.bastion_ssh_sg.security_group_id, module.private_ssh_sg.security_group_id]
}