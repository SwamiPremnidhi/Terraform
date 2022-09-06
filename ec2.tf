
provider "aws" {
  region = "us-east-1"
}


variable "instancetag" {
  type = list
  default = ["dev", "test", "prod"]

}


resource "aws_security_group" "webserverSG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.main.id
 
  

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

    ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

   ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

    ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "webserveSG"
  }
}



resource "aws_instance" "webserver" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserverSG.id]
  subnet_id = aws_subnet.main.id
  count = 3
  key_name = "sapan-pub"

  tags = {
    Name = var.instancetag[count.index]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "sapan-pub"

  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9Msv6v9dYElLa8dUbreo7UE80VqlYrb+KegjJPHJ43lVyIuErc0j3Pyf4iN3+hI+TnGEsw2w0J7Pu2Vu/I8JxKTaegV5kPUZAn500Wa1IlaIvW/W6kugYcAnsKkB960XrQpLpsHDRQNy04LtuaasU9kmSzzSzG1YTuY0qf/vA1F6bkvHPFbp7+FRQwfLNRkZySXF9wOZvIW/lEvsBQ2/5iDO8leW7VNLctl4YBgMy+CBKW9Ypd5n3wLMO09F6m9SQrBNPKYSVSH0fbBPMOxGa27gPloj/skk8M55Ff8nlaDLsIjDXdMAji8Oz1+UosHkTpY3RoRiuRMfZEjhOyGaB root@ip-172-31-91-176.ec2.internal"
  }


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Sapangw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

 tags = {
    Name ="public-rt"
  }
}


  resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public-rt.id
}


