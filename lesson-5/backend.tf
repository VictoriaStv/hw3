terraform {
  backend "s3" {
    bucket         = "lesson-5-terraform-state-vika"  # можете змінити, але має бути УНІКАЛЬНИЙ bucket name
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
