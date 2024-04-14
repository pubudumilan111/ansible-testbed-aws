region               = "us-east-1"
key_name             = "key-ansible"
master_instance_type = "t2.medium"
host_instance_type   = "t2.micro"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_cidr  = "10.0.2.0/24"
availability_zones   = ["us-east-1a", "us-east-1b"]