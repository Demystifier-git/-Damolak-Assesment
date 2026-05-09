terraform {
  backend "s3" {
    bucket         = "damolak-bucket-18746468390"
    key            = "damolak-assessment/terraform.tfstate"
    region         = "us-east-1"

    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}