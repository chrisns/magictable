variable "url" {
  description = "location"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.url
  acl    = "public-read"
  force_destroy = false
  website {
    index_document = "index.html"
  }
  tags = {
    customer = "magictable"
    site = var.url
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode(
            {
               Statement = [
                   {
                       Action    = "s3:GetObject"
                       Effect    = "Allow"
                       Principal = "*"
                       Resource  = "arn:aws:s3:::${var.url}/*"
                       Sid       = "AddPerm"
                    },
                ]
               Version   = "2012-10-17"
            }
        ) 
}

resource "aws_route53_zone" "zone" {
  name = replace(var.url, "www.", "")
  tags = {
    customer = "magictable"
    site = var.url
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 86400
  records        = ["${var.url}.s3-website.eu-west-2.amazonaws.com"]
}

resource "aws_route53_record" "no-www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = ""
  type    = "A"
  ttl     = 86400
  records        = ["45.55.72.95"]
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "_redirect"
  type    = "TXT"
  ttl     = 86400
  records        = ["Redirects from /* to http://${var.url}/*"]
}

output "dns" {
  value = {
    domain = replace(var.url, "www.", "")
    nameservers = length(cloudflare_zone.zone) > 0 ? cloudflare_zone.zone[0].name_servers : ["none"]
  }
}

resource "cloudflare_zone" "zone" {
  count = substr(var.url,0,4) == "demo" ? 0 : 1
  zone = replace(var.url, "www.", "")
  plan = "free"
}

resource "cloudflare_record" "www" {
  count = substr(var.url,0,4) == "demo" ? 0 : 1
  zone_id = cloudflare_zone.zone[count.index].id
  name    = "www"
  value   = "${var.url}.s3-website.eu-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "A" {
  count = substr(var.url,0,4) == "demo" ? 0 : 1
  zone_id = cloudflare_zone.zone[count.index].id
  name    = "@"
  value   = "45.55.72.95"
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "txt" {
  count = substr(var.url,0,4) == "demo" ? 0 : 1
  zone_id = cloudflare_zone.zone[count.index].id
  name    = "_redirect"
  value   = "Redirects from /* to http://${var.url}/*"
  type    = "TXT"
  ttl     = 3600
}
