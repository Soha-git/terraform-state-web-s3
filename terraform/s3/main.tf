
terraform {
    # backend "s3" {
    #     bucket = "terraform-state-backet"
    #     encrypt = true
    #     key = "s3/terraform.tfstate"
    #     region = "us-east-1"
    #     dynamodb_table = "terraform_stake_lock"
    # }
    required_providers {
      aws = {
        version = "~> 3.0"
      }
    }
    required_version = ">=0.13"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "static_web_site" {
  bucket = var.s3_bucket
  acl    = "public-read"
    
    website {
      index_document = "index.html"
    }
    
  tags = {
    "Name" = var.s3_bucket
  }
}

resource "aws_s3_bucket_policy" "allow_access" {

  bucket = aws_s3_bucket.static_web_site.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
    statement {
      principals {
        type = "*"
        identifiers = ["*"]
      }
        actions = [
            "s3:GetObject",
            "s3:ListBucket",
        ]

        resources = [
            aws_s3_bucket.static_web_site.arn,
            "${aws_s3_bucket.static_web_site.arn}/*"
        ]
    }
}

resource "aws_s3_bucket_public_access_block" "web-site-acces-block" {
  bucket = aws_s3_bucket.static_web_site.id
  block_public_acls = true
  block_public_policy = false
  ignore_public_acls = true
  restrict_public_buckets = false
}
