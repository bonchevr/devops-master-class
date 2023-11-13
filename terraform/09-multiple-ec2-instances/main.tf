provider "aws" {
  region  = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  vpc_id = "vpc-0c8528ae0d41d9b0a"
  //vpc_id = "aws_default_vpc.default"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  #ami                   = "ami-062f7200baf2fa504"
  count                  = 3
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "DebianVM_key"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  //subnet_id              = "subnet-3f7b2563"
  subnet_id = data.aws_subnets.default_subnets.ids[0]
}