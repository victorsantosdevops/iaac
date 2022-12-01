# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}
provider "github" {
  owner = "mosaic-builders"
  organization = "mosaic-builders"
}

