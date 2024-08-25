provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "E:/Terraform/AWS Architecture/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source              = "E:/Terraform/AWS Architecture/subnets"
  vpc_id               = module.vpc.vpc_id
  vpc_name             = module.vpc.vpc_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "nat_gateway" {
  source          = "E:/Terraform/AWS Architecture/nat_gateway"
  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.subnets.public_subnet_ids[0]
}

module "route_tables" {
  source               = "E:/Terraform/AWS Architecture/route_tables"
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  nat_gateway_id       = module.nat_gateway.nat_gateway_id
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
}

module "bastion_host" {
  source          = "E:/Terraform/AWS Architecture/bastion_host"
  vpc_id           = module.vpc.vpc_id
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  public_subnet_id = module.subnets.public_subnet_ids[0]
  key_name         = var.key_name
}

module "private_servers" {
  source               = "E:/Terraform/AWS Architecture/private_servers"
  vpc_id               = module.vpc.vpc_id
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  private_subnet_1_id  = module.subnets.private_subnet_ids[0]
  private_subnet_2_id  = module.subnets.private_subnet_ids[1]
  key_name             = var.key_name
  bastion_sg_id        = module.bastion_host.bastion_sg_id
}

resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

module "alb" {
  source                = "E:/Terraform/AWS Architecture/alb"  
  vpc_id                = module.vpc.vpc_id
  alb_name              = "clops-alb"
  target_group_name     = "clops-target-group"
  alb_subnet_ids        = module.subnets.public_subnet_ids

  alb_security_group_id = aws_security_group.alb_sg.id

  private_server_1_id   = module.private_servers.private_server_1_id
  private_server_2_id   = module.private_servers.private_server_2_id
}


module "rds" {
  source                = "E:/Terraform/AWS Architecture/rds"
  vpc_id                = module.vpc.vpc_id
  db_subnet_group_name  = "clops-db-private-subnet-group"
  db_subnet_ids         = module.subnets.private_subnet_ids  # Use all private subnets
  db_name               = "clopsdb"
  db_username           = var.db_username
  db_password           = var.db_password
  app_server_sg_ids     = [module.private_servers.private_server_sg_id]  # SG ID from private servers
}

module "iam" {
  source = "E:/Terraform/AWS Architecture/iam"  # Adjust to your local module path
  iam_user_name = var.iam_user_name
}

module "s3" {
  source      = "E:/Terraform/AWS Architecture/s3"
  bucket_name = var.bucket_name
}