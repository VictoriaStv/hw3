terraform {
  backend "s3" {
    bucket         = "lesson-5-terraform-state-vika" # той самий bucket, що й у lesson-5
    key            = "lesson-7/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
