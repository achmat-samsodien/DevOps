provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

terraform {
  backend "s3" {
    bucket = "blkswan-tfstate"
    key    = "bs-key"
    region = "eu-west-1"
  }
}