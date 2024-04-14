variable "region" {
  description = "AWS region"
  type        = string
}

variable "availability_zones" {
  type = list(string)
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "master_instance_type" {
  description = "Instance type for the master node"
  type        = string
}

variable "host_instance_type" {
  description = "Instance type for the host node"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}


