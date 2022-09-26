provider "aws" {
    profile = "myaws"
    region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
    aws_s3_bucket_acl = var.acl
}
variable "bucket_name" {
    type = string
    default = "swami12345"
}

variable "acl" {
  type = string
  default = "public-read"
}

variable "region"{
    type = string
    default = "us-east-1"
}
