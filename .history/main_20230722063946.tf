
# Pull ami ID based on filters
data "aws_ami" "linux2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230207.0-x86_64-gp2"]

  }

  owners = ["amazon"]
}

#Creating ec2 instance

resource "aws_instance" "ec2_example" {
    ami = data.aws_ami.linux2.id
    instance_type = "t2.medium"
    tags = {
      Name ="${terraform.workspace}-instance"
    }
}

# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = "10.50.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Demo-VPC"
  }
}

