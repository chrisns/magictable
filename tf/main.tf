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

module "demo" {
  source     = "./modules/bucket"
  url       = "demo.zoomfab.info"
}

module "rotten100films" {
  source     = "./modules/bucket"
  url       = "www.rotten100films.com"
}

module "rottenfilms100" {
  source     = "./modules/bucket"
  url       = "www.rottenfilms100.com"
}

module "thetoptomato100" {
  source     = "./modules/bucket"
  url       = "www.thetoptomato100.com"
}

module "rt100films" {
  source     = "./modules/bucket"
  url       = "www.rt100films.com"
}

module "tomatoes100" {
  source     = "./modules/bucket"
  url       = "www.tomatoes100.com"
}

module "toms100films" {
  source     = "./modules/bucket"
  url       = "www.toms100films.com"
}

module "rt100movies" {
  source     = "./modules/bucket"
  url       = "www.rt100movies.com"
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




# legacy route53 dns

#rottenfilms100.com

resource "aws_route53_zone" "rottenfilms100_com" {
  name = "rottenfilms100.com"
  tags = {
    customer = "magictable"
    site = "www.rottenfilms100.com"
  }
}

resource "aws_route53_record" "rottenfilms100_com_www" {
  zone_id = aws_route53_zone.rottenfilms100_com.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 86400
  records        = ["www.rottenfilms100.com.s3-website.eu-west-2.amazonaws.com"]
}

# resource "aws_route53_record" "rottenfilms100_com_nowww" {
#   zone_id = aws_route53_zone.rottenfilms100_com.zone_id
#   name    = ""
#   type    = "A"
#   ttl     = 86400
#   records        = ["45.55.72.95"]
# }

resource "aws_route53_record" "rottenfilms100_com_txt" {
  zone_id = aws_route53_zone.rottenfilms100_com.zone_id
  name    = "_redirect"
  type    = "TXT"
  ttl     = 86400
  records        = ["Redirects from /* to http://www.rottenfilms100.com/*"]
}

#rottenfilms100.com

resource "aws_route53_zone" "thetoptomato100_com" {
  name = "thetoptomato100.com"
  tags = {
    customer = "magictable"
    site = "www.thetoptomato100.com"
  }
}

resource "aws_route53_record" "thetoptomato100_com_www" {
  zone_id = aws_route53_zone.thetoptomato100_com.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 86400
  records        = ["www.thetoptomato100.com.s3-website.eu-west-2.amazonaws.com"]
}

# resource "aws_route53_record" "thetoptomato100_com_nowww" {
#   zone_id = aws_route53_zone.thetoptomato100_com.zone_id
#   name    = ""
#   type    = "A"
#   ttl     = 86400
#   records        = ["45.55.72.95"]
# }

resource "aws_route53_record" "thetoptomato100_com_txt" {
  zone_id = aws_route53_zone.thetoptomato100_com.zone_id
  name    = "_redirect"
  type    = "TXT"
  ttl     = 86400
  records        = ["Redirects from /* to http://www.thetoptomato100.com/*"]
}