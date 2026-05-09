variable "vpc_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "allowed_sg_id" {
  description = "EC2/ASG security group allowed to access DB"
}

variable "db_name" {}

variable "master_username" {}

variable "master_password" {
  sensitive = true
}

variable "instance_class" {}

variable "instance_count" {
  type = number
}