#configuring tomcat server

provider "aws" {
  region = "us-east-1"  # replace with your desired region
  access_key= "AKIA5SIDS5XFIVMVM5KQ"
  secret_key = "A19SRhI1H1tuTA7RTFn4fWZjw72G7IekSOjAjVY0"
}

resource "aws_key_pair" "key-tf" {
  key_name = "key-tf"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "Tomcat_server" {
  ami           = "ami-005f9685cb30f234b"  # aws linux
  instance_type = "t2.micro"  # replace with your desired instance type
  tags = {
    Name = "Tomcat"
  }
  key_name      = "${aws_key_pair.key-tf.key_name}"  # replace with your SSH key name
  security_groups = ["default"]  # replace with your desired security group(s)

  connection {
    type        = "ssh"
    user        = "ec2-user"  # replace with your desired username
    # private_key = file("/home/sheraz/Downloads/new_tomcat_key.pem")  # replace with your SSH key path
    host        = self.public_ip
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y java-1.8.0-openjdk",
      "sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.tar.gz -P /tmp",
      "sudo tar -xzvf /tmp/apache-tomcat-9.0.54.tar.gz -C /opt",
      "sudo ln -s /opt/apache-tomcat-9.0.54 /opt/tomcat",
      "sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'"
    ]
  }
}