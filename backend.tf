terraform {
  backend "s3" {
    bucket         = "clopsterraformstatefile"  
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
