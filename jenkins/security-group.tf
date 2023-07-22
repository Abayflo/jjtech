data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Allow HTTP to jenkins server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "http ingress"
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "http ingress"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    prevent_destroy = true
  }
}