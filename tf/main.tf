provider "aws" {
  region  = "eu-west-2"
}

locals {
  sites = ["www.rotten100.com", "demo.zoomfab.info"]
}

module "rotten100" {
  source     = "./modules/bucket"
  url       = "www.rotten100.com"
}

output "rotten100" {
    value = module.rotten100.dns
}

module "demo" {
  source     = "./modules/bucket"
  url       = "demo.zoomfab.info"
}

output "demo" {
    value = module.demo.dns
}

module "rotten100films" {
  source     = "./modules/bucket"
  url       = "www.rottenfilms100.com"
}

output "rotten100films" {
    value = module.rotten100films.dns
}