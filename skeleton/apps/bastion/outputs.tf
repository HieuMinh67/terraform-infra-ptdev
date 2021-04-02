
    output "public_ip" {
      value = module.bastion.public_ip
      }
      
      output "security_group_id" {
        value = module.bastion.sg_id
          }
