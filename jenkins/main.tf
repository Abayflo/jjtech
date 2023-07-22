

# Data source to get the access to the effective Account ID, 
# User ID, and ARN in which Terraform is authorized
data "aws_caller_identity" "current" {}


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


# Resource to provision an ec2 instance with jenkins installed

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.linux2.id
  instance_type   = "t2.medium"
  key_name        = "jenkinskeypair" #Replace with your key name
  security_groups = [aws_security_group.jenkins.name]
  iam_instance_profile = "EC2RoleforAdmins"


  tags = {
    Name = "Jenkins-Demo"
  }

  user_data = file("jenkins-install.sh")

#   lifecycle {
#     prevent_destroy = true
#   }
}


