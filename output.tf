provider "aws" {
    profile = "myaws"
    region = var.region1
}
resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name1
    acl = var.acl1

    tags = {
      Name = "My bucket"
      Environment = "Dev"
    }
}



variable "bucket_name1" {
    type = string
    default = "swami12345"
}

variable "acl1" {
  type = string
  default = "public-read"
}
variable "region1"{
    type = string
    default = "us-east-1"
}

output "name_of_storage_account" {
    value = aws_s3_bucket.bucket.bucket
}
output "acl_value" {
    value =  aws_s3_bucket.bucket.acl
}
output "tags" {
    value = aws_s3_bucket.bucket.tags
  
}
