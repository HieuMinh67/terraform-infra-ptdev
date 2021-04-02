
    output "public_ip" {
      value = module.bastion.bastion_ip
      }
      
      output "security_group_id" {
        value = module.bastion.bastion_sg_id
          }
