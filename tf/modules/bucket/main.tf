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
            "Resource": "arn:aws:s3:::${var.url}/*"
            
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = "lee-test-executor"
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_route53_zone" "zone" {
  name = replace(var.url, "www.", "")
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
  value = aws_route53_zone.zone.name_servers
}
