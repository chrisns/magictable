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
  url       = "www.rotten100films.com"
}

output "rotten100films" {
    value = module.rotten100films.dns
}

module "rottenfilms100" {
  source     = "./modules/bucket"
  url       = "www.rottenfilms100.com"
}

output "rottenfilms100" {
    value = module.rottenfilms100.dns
}

module "thetoptomato100" {
  source     = "./modules/bucket"
  url       = "www.thetoptomato100.com"
}

output "thetoptomato100" {
    value = module.thetoptomato100.dns
}

module "rt100films" {
  source     = "./modules/bucket"
  url       = "www.rt100films.com"
}

output "rt100films" {
    value = module.rt100films.dns
}

module "tomatoes100" {
  source     = "./modules/bucket"
  url       = "www.tomatoes100.com"
}

output "tomatoes100" {
    value = module.tomatoes100.dns
}

module "toms100films" {
  source     = "./modules/bucket"
  url       = "www.toms100films.com"
}

output "toms100films" {
    value = module.toms100films.dns
}

module "rt100movies" {
  source     = "./modules/bucket"
  url       = "www.rt100movies.com"
}

output "rt100movies" {
    value = module.rt100movies.dns
}

