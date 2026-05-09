# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

# Subnets
module "subnets" {
  source = "./modules/subnets"

  vpc_id            = module.vpc.vpc_id
  availability_zones = var.availability_zones
}

# Internet Gateway
module "igw" {
  source = "./modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
}

# NAT Gateway
module "nat" {
  source = "./modules/nat-gateway"

  # NAT Gateway requires ONE public subnet
  public_subnet_id = module.subnets.public_subnet_ids[0]

  depends_on = [module.igw]
}

# Route Tables
module "routes" {
  source = "./modules/route-tables"

  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  nat_id = module.nat.nat_id

  # Route module expects LISTS
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}

# Security Groups
module "web_sg" {
  source = "./modules/security-group-ec2"

  vpc_id = module.vpc.vpc_id
  sg_name = "ec2-sg"

}

module "vpc_sg" {
  source = "./modules/security-group-VPC"

  vpc_id = module.vpc.vpc_id
  sg_name = "vpc-sg"
}

# EC2
module "ec2" {
  source = "./modules/ec2"

  name          = "web-server"
  instance_type = "t3.micro"

  # EC2 expects ONE subnet
  subnet_id = module.subnets.private_subnet_ids[0]

  security_group_ids = [module.web_sg.sg_id]

  ami       = var.ec2_ami
  instance_type = var.instance_type
}

# Load Balancer + SSL
module "lb_ssl" {
  source = "./modules/lb_ssl"

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.subnets.public_subnet_ids

  target_instance_id = module.ec2.instance_id

  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn
}

# Route53
module "route53" {
  source = "./modules/route53"

  hosted_zone_id = var.hosted_zone_id

  domain_name = var.domain_name
  subdomain   = var.subdomain

  lb_dns_name = module.lb_ssl.lb_dns_name
  lb_zone_id  = module.lb_ssl.lb_zone_id
}

# Auto Scaling Group
module "ec2_asg" {
  source = "./modules/ec2-asg"

  private_subnets     = module.subnets.private_subnet_ids
  security_group_ids  = [module.web_sg.sg_id]
  target_group_arn    = module.lb_ssl.target_group_arn

  key_name            = var.key_name
  ec2_ami             = var.ec2_ami
  instance_type       = var.instance_type

  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
}

# DocumentDB
module "documentdb" {
  source = "./modules/documentdb"

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.subnets.private_subnet_ids

  # Allow EC2 SG access to DocumentDB
  allowed_sg_id = module.web_sg.sg_id

  db_name = var.db_name

  master_username = var.docdb_username
  master_password = var.docdb_password

  instance_class = var.docdb_instance_class
  instance_count = var.docdb_instance_count
}