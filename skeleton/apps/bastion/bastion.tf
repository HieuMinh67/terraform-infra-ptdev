  module "bastion" {
  source            = "github.com/BeanTraining/terraform-aws-bastion-host"  
  subnet_id         = var.subnet_id
  ssh_key           = "deployer-key"
  internal_networks = var.internal_networks
  disk_size         = 12
  instance_type     = "t2.micro"
  project           = var.app_name
}
  
    output "bastion_ip" {
      value = module.bastion.public_ip
      }
      
      output "bastion_sg_id" {
        value = module.bastion.sg_id
          }
