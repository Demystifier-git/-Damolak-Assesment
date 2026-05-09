variable "aws_region" {
  type    = string
  
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
 
}

variable "availability_zones" {
  description = "List of availability zones to create subnets in"
  type        = list(string)
  
}



variable "ec2_ami" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM SSL certificate"
  type        = string
}

variable "domain_name" {
  description = "main Domain name for the application"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application"
  type        = string
  
}


variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}


variable "db_username" {
  description = "Master username for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_engine_version" {
  description = "MySQL engine version for the RDS instance"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance in GB"
  type        = number
}

variable "db_sg_name" {
  description = "Name of the database security group"
  type        = string
  default     = "db-new"
}

variable "db_name" {
  description = "Name of database"
  type        = string
}