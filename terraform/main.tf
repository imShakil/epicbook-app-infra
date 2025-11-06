provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu_ami" {
    most_recent = true
    owners = ["099720109477"]

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}

module "network" {
  source = "git::https://github.com/imShakil/tfmodules.git//aws/vpc"
  cidr_block = var.cidr_block
  prefix = var.prefix
}

module "vm" {
  source = "git::https://github.com/imShakil/tfmodules.git//aws/instance"

  ami_id = data.aws_ami.ubuntu_ami.id
  subnet_id = module.network.vpc_attribute.public_subnet_ids[0]
  vpc_security_group_ids = [module.network.vpc_attribute.security_group_id]
  ssh_key_pair = {
    ssh_username = "${var.prefix}-ssh-key"
    ssh_key_path = var.ssh_key_path
  }
}

module "db" {
  source = "git::https://github.com/imShakil/tfmodules.git//aws/rds"
  prefix = var.prefix
  security_group_ids = [module.network.vpc_attribute.security_group_id]
  private_subnets = module.network.vpc_attribute.private_subnet_ids
  rds_admin = var.db_admin
  rds_admin_password = var.db_admin_password
  rds_name = "${var.prefix}DB"
  
}
