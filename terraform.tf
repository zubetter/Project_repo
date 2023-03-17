provider "aws" {
  region = "us-east-1"  # replace with your desired region
  access_key= "AKIA5SIDS5XFJNOSDILB"
  secret_key = "KnBdFI39qniwt+DbkTJvicLqIytR9DNT1L94tCG/"
}
# Create EC2 instance
resource "aws_instance" "docker" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  key_name      = "new_tomcat_key"
#  resource "aws_vpc" "default" {
#   cidr_block = "10.0.0.0/16"
# }


  # Define user data to install Docker on instance start up
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              EOF

  # Define tags for instances.
  tags = {
    Name = "docker-instance"
  }
}

Output instance public IP address
output "public_ip" {
  value = aws_instance.docker.public_ip
}