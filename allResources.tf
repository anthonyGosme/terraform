resource "aws_vpc" "vpcTestAR" {
  cidr_block = "192.168.1.0/24"
  tags =  {
    Name = "VPC public AR"
  }
}

resource "aws_subnet" "reseauAR" {
  vpc_id = aws_vpc.vpcTestAR.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "eu-west-3b"
  tags =  {
    Name = "Reseau public AR"
  }
}

resource "aws_internet_gateway" "igAR" {
  vpc_id = aws_vpc.vpcTestAR.id
  tags =  {
    Name = "passerelle internet AR"
  }
}
resource "aws_route" "routeAR" {
  route_table_id  = aws_vpc.vpcTestAR.default_route_table_id
  gateway_id = aws_internet_gateway.igAR.id
  destination_cidr_block =  "0.0.0.0/0"

}

resource "aws_security_group" "Serveur-GSAR"{
  vpc_id = aws_vpc.vpcTestAR.id
  name ="Acces-SSH-AR"
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    # tous les protocols
    protocol = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }
}


resource "aws_instance" "ServeurWebAR"{
    ami ="ami-078db6d55a16afc82"
    instance_type ="t2.micro"
    key_name ="serveurTF"
    vpc_security_group_ids =[aws_security_group.Serveur-GSAR.id]
    subnet_id = aws_subnet.reseauAR.id
    associate_public_ip_address = true
    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y apache2
                EOF
    tags = {
        Name = "Serveur web All Ressource" 
    }

}

resource "aws_eip" "ip"{
    instance =aws_instance.ServeurWebAR.id
}