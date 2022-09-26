provider "aws" {
    profile = "myaws"
    region = "us-east-1"
}

resource "aws_vpc" "main" {
    cidr_block = "172.23.0.0/16"
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "172.23.10.0/24"
  
  tags = {
    Name = "Main"
  }
}

resource "aws_network_interface" "test" {
    subnet_id =  aws_subnet.main.id
    private_ips = [ "172.23.10.131","172.23.10.232" ]  
}

resource "aws_instance" "foo" {
  ami = "ami-05fa00d4c63e32376" #us-east-1
  instance_type = "t2.micro"


 network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index = 0
 }
} 
