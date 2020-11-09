provider "aws"{
  region = "eu-west-3"
  access_key = var.accesskey
  secret_key = var.secretkey
}


resource "aws_instance" "ServeurWeb"{
    ami ="ami-078db6d55a16afc82"
    instance_type ="t2.micro"
    key_name ="serveurTF"
    vpc_security_group_ids =[aws_security_group.ServeurWeb-GS.id]
    tags = {
        Name = "Serveur web" 
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y apache2
                EOF
    
    provisioner "file" {
      source ="test.txt"
      destination = "/home/ubuntu/test.txt"
      connection {
        type ="ssh"
        user = "ubuntu"
        host = self.public_ip
        private_key = file("serveurTF.pem")
      }
    }
}

resource "aws_security_group" "ServeurWeb-GS"{
  name ="Acces-SSH-HTTP"
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "available" {}

module groupeSsh {

  source = "./module/securityGroup"
  nomGroup = "test modules SSH"
  fromPort = "22"
  toPort ="22"
  protocol = "tcp"
  cidr = ["0.0.0.0/0"]
}

