provider "aws" {
    region = "ap-south-1"
    profile = "myaws"
}
provider "aws"{
    region = "kjnn"
    access_key = "nnkjkj"
    secret_key = "nkjk"
    alias = "swami" # this is imp to define for provisiong in other account and other resion
}

locals {
    instance_name="$(terraform.workspace)-instance"  #  this is when u are using workspace concept 
}

resource "aws_instance" "swamy-ec2" {
instance_type = "t2.micro"
ami="ami-0123ttu777"
provider=aws.swamy   #imp
tags={
    Name = local.instance_name # to call local variable
  }
}

