terraform {

  backend "s3" {
    bucket = "terraform-suji"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}