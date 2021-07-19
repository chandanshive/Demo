provider "aws" {
  region = "us-east-2"
}

#creating security group to allow ssh and http

resource "aws_security_group" "hello-terra-ssh-http" {
  name        = "hello-terra-ssh-http"
  description = "allow ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating aws EC2 instance

resource "aws_instance" "hello-terra" {
  ami = "ami-01e36b7901e884a10"
  instance_type = "t2.micro"
  availability_zone = "us-east-2c"
  security_groups = "$aws_security_group.hello-terra-ssh-http.name"
  key_name = "Akshay-aws"
  user_data = <<-EOF
    #! /bin/bash
    sudo yum install epel-release
    sudo yum install nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<h1>My Nginx Web-Server</h1>" >> /var/www/html.index.html
  EOF

  tags = {
    Name = "Webserver"
  }
}
