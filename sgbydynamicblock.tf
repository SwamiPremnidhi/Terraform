provider "aws" {
    profile = "myaws"
    region = "us-east-1"
}

resource "aws_vpc" "swami" {
    cidr_block = "10.0.0.0/16"
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.swami.id

   dynamic "ingress" {
    for_each = var.aws_sg

    content { 
    description      = ingress.value.description
    from_port        = ingress.value.port
    to_port          = ingress.value.port
    protocol         = ingress.value.protocol
    cidr_blocks      = ingress.value.cidr_blocks
    }
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_tls"
    }

}

variable "aws_sg" {
    type = map(object({
        description = string
        port = number
        protocol = string
        cidr_blocks = list(string)
    }))

    default = {
      "80" = {
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "tls_rule1"
        port = 80
        protocol = "tcp"
      }
     "443" = {
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "tls_rule2"
        port = 443
        protocol = "tcp"
      }
}
  
}
