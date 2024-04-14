data "aws_ami" "aws_ami_ec2" {
  most_recent = true

  filter {
 name = "name"
 values = ["RHEL-9.3.0_HVM-*-x86_64-49-Hourly2-GP3"]
 }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["amazon"]

}

resource "aws_instance" "ansible_master" {
  ami             = data.aws_ami.aws_ami_ec2.id
  instance_type   = var.master_instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.ansible_public_subnet.id
  security_groups = [aws_security_group.ansible_sg.id]
  tags = {
    Name = "ansible-master-instance"
  }
}

resource "aws_instance" "ansible_host" {
  ami             = data.aws_ami.aws_ami_ec2.id
  instance_type   = var.host_instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.ansible_private_subnet.id
  security_groups = [aws_security_group.host_sg.id]
  tags = {
    Name = "ansible-host-instance"
  }
}
