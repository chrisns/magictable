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
              "arn:aws:s3:::www.rottenfilms100.com/index.html",
              "arn:aws:s3:::www.thetoptomato100.com/index.html",
              "arn:aws:s3:::www.tomatoes100.net/index.html",
              "arn:aws:s3:::www.rotten100.uk"
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

module "demo" {
  source     = "./modules/bucket"
  url       = "demo.zoomfab.info"
}

module "rottenfilms100" {
  source     = "./modules/bucket"
  url       = "www.rottenfilms100.com"
}

module "thetoptomato100" {
  source     = "./modules/bucket"
  url       = "www.thetoptomato100.com"
}

module "_100rotten_com" {
  source     = "./modules/bucket"
  url       = "www.100rotten.com"
}

module "_100rotten_net" {
  source     = "./modules/bucket"
  url       = "www.100rotten.net"
}

module "tomatoes100_net" {
  source     = "./modules/bucket"
  url       = "www.tomatoes100.net"
}

module "rotten100_net" {
  source     = "./modules/bucket"
  url       = "www.rotten100.net"
}

module "rotten100_uk" {
  source     = "./modules/bucket"
  url       = "www.rotten100.uk"
}
