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

variable "aws_secret_access_key" {
  type = string
  default = "aws_secret_access_key"
  }
variable "aws_access_key_id" {
  type = string
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

  // copy our example script to the server
  provisioner "file" {
    source      = "files/terraform-init.sh"
    destination = "~/terraform-init.sh"
  }

  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [  
      "chmod +x ~/terraform-init.sh",
      "~/terraform-init.sh '${var.github_oauth_token}' '${var.tfe_token}' '${var.aws_access_key_id}' '${var.aws_secret_access_key}' '${var.aws_region}' > ~/terraform-init.log"
    ]
  }

 # provisioner "local-exec" {
    # copy the public-ip file back to CWD, which will be tested
   # command = "scp -i /home/centos/bastion.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${aws_instance.example_public.public_ip}:/tmp/public-ip public-ip"
 # }
}

# ---------------------------------------------------------------------------------------------------------------------
# LOOK UP THE LATEST UBUNTU AMI
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}









# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "private_key" {
  type = string
  }
variable "key_pair_name" {
  description = "The EC2 Key Pair to associate with the EC2 Instance for SSH access."
  type        = string
  default = "deployer-key"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_name" {
  description = "The Name tag to set for the EC2 Instance."
  type        = string
  default     = "terratest-example"
}

variable "ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  type        = string
  default     = "centos"
}

variable "instance_type" {
  description = "Instance type to use for EC2 Instance"
  type        = string
  default     = "t2.micro"
}



output "public_instance_id" {
  value = aws_instance.example_public.id
}

output "public_instance_ip" {
  value = aws_instance.example_public.public_ip
}
