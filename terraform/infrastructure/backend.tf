terraform {
  backend "s3" {
    bucket       = "ahkash-project02-tfstate-106523033931"
    key          = "project02/infrastructure/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}