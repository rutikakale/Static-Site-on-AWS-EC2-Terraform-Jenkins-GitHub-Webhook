provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "web" {
  ami           = "ami-0d176f79571d18a8f"   
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web-sg.name]
  associate_public_ip_address = true
  key_name = "terraform"
  user_data = file("user_data.sh")
  tags = {
    Name = "StaticWebServer"
  }
}
