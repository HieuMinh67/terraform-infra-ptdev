# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE EC2 INSTANCE WITH A PUBLIC IP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "example_public" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.example.id]
  key_name               = var.key_pair_name

  # This EC2 Instance has a public IP and will be accessible directly from the public Internet
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name}-public"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF THE EC2 INSTANCES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "example" {
  name = var.instance_name

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.ssh_port
    to_port   = var.ssh_port
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Provision the server using remote-exec
# ---------------------------------------------------------------------------------------------------------------------

resource "null_resource" "example_provisioner" {
  triggers = {
    public_ip = module.bastion.public_ip
    random_str = "123"
  }

  connection {
    type  = "ssh"
    host  = module.bastion.public_ip
    user  = var.ssh_user
    port  = var.ssh_port
    agent = false
    private_key = var.private_key
  }

  // copy our example script to the server
  provisioner "file" {
    source      = "files/get-public-ip.sh"
    destination = "/tmp/get-public-ip.sh"
  }
  provisioner "file" {
    source      = "files/terraform-init.sh"
    destination = "~/terraform-init.sh"
  }

  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/get-public-ip.sh",
      "/tmp/get-public-ip.sh > /tmp/public-ip",
      
      "chmod +x ~/terraform-init.sh",
      "~/terraform-init.sh '${var.github_oauth_token}' '${var.tfe_token}' '${var.aws_access_key_id}' '${var.aws_secret_access_key}' '${var.aws_region}' > ~/terraform-init.log",
      "terraform apply -auto-approve"
    ]
  }

      provisioner "remote-exec" {
        when = "destroy"
    inline = [
      "cd environments/master/apps/main/example/k8s",
      "terraform destroy -auto-approve"
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
