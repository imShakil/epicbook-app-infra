terraform {
  backend "s3" {
    bucket       = "imshakil-bkt-tfstate"
    key          = "epkbkazure-terraform.tfstate"
    use_lockfile = true
    region       = "ap-southeast-1"
  }
}