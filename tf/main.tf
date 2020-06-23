terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "chrisns"

    workspaces {
      name = "magictable"
    }
  }
}

provider "aws" {
  region  = "eu-west-2"
}

provider "cloudflare" {
  version = "~> 2.0"
  email   = "chris@cns.me.uk"
}

resource "aws_iam_policy" "policy" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
              "arn:aws:s3:::demo.zoomfab.info/index.html",
              "arn:aws:s3:::www.100rotten.com/index.html",
              "arn:aws:s3:::www.100rotten.net/index.html",
              "arn:aws:s3:::www.rotten100.com/index.html",
              "arn:aws:s3:::www.rotten100.net/index.html",
              "arn:aws:s3:::www.rotten100films.com/index.html",
              "arn:aws:s3:::www.rt100films.com/index.html",
              "arn:aws:s3:::www.rt100movies.com/index.html",
              "arn:aws:s3:::www.thetoptomato100.com/index.html",
              "arn:aws:s3:::www.tomatoes100.com/index.html",
              "arn:aws:s3:::www.tomatoes100.net/index.html",
              "arn:aws:s3:::www.rotten100.uk",
              "arn:aws:s3:::www.toms100films.com/index.html"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = "lee-test-executor"
  policy_arn = aws_iam_policy.policy.arn
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

module "_100rotten_com" {
  source     = "./modules/bucket"
  url       = "www.100rotten.com"
}

output "_100rotten_com" {
    value = module._100rotten_com.dns
}

module "_100rotten_net" {
  source     = "./modules/bucket"
  url       = "www.100rotten.net"
}

output "_100rotten_net" {
    value = module._100rotten_net.dns
}

module "tomatoes100_net" {
  source     = "./modules/bucket"
  url       = "www.tomatoes100.net"
}

output "tomatoes100_net" {
    value = module.tomatoes100_net.dns
}

module "rotten100_net" {
  source     = "./modules/bucket"
  url       = "www.rotten100.net"
}

output "rotten100_net" {
    value = module.rotten100_net.dns
}

module "rotten100_uk" {
  source     = "./modules/bucket"
  url       = "www.rotten100.uk"
}

output "rotten100_uk" {
    value = module.rotten100_uk.dns
}
