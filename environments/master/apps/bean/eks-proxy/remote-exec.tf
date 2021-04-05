terraform {
  required_version = ">= 0.12.0"
    backend "remote" {
          hostname = "app.terraform.io"

    organization = "BeanTraining"

    workspaces {
      name = "example-k8s-proxy"
    }
  }

}

provider "aws" {
  version = ">= 3.25.0"
  region  = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE EC2 INSTANCE WITH A PUBLIC IP
# ---------------------------------------------------------------------------------------------------------------------

data "terraform_remote_state" "backend" {
  backend = "remote"

  config = {
    organization = "BeanTraining"
    workspaces = {
      name = "example"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Provision the server using remote-exec
# ---------------------------------------------------------------------------------------------------------------------
resource "null_resource" "example_provisioner" {
  triggers = {
    public_ip = data.terraform_remote_state.example.outputs.bastion_ip
    random_str = "123"
      ssh_user = var.ssh_user
      ssh_port = var.ssh_port
      private_key = var.private_key
  }

    connection {
    type  = "ssh"
    host  = self.triggers.public_ip
    user  = self.triggers.ssh_user
    port  = self.triggers.ssh_port
    agent = false
    private_key = self.triggers.private_key
  }

  provisioner "file" {
    source      = "files/terraform-apply.sh"
    destination = "~/terraform-apply.sh"
  }
  provisioner "file" {
    source      = "files/terraform-destroy.sh"
    destination = "~/terraform-destroy.sh"
  }

  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/terraform-apply.sh",
      "~/terraform-apply.sh > ~/terraform-apply.log"
    ]
  }

      provisioner "remote-exec" {
        when = destroy
    inline = [
      "chmod +x ~/terraform-destroy.sh",
      "~/terraform-destroy.sh eks> ~/terraform-destroy.log"
    ]
  }

 # provisioner "local-exec" {
    # copy the public-ip file back to CWD, which will be tested
   # command = "scp -i /home/centos/bastion.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${aws_instance.example_public.public_ip}:/tmp/public-ip public-ip"
 # }
}