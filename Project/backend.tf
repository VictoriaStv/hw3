terraform {
  backend "s3" {
    bucket         = "lesson-5-terraform-state-vika"
    key            = "final-project/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
