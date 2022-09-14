terraform {
  # backend "s3" {
  #       bucket = "terraform-state-backet"
  #       encrypt = true
  #       key = "backend/terraform.tfstate"
  #       region = "us-east-1"
  #       dynamodb_table = "terraform_stake_lock"
  #   }
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

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.dynamodb_table
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "Name"        = var.dynamodb_table
    "Description" = "DynamoDB terraform table to local state"
  }

}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_backet

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
	lifecycle {
		prevent_destroy = true 
	}
	tags = {
      "Name"        = var.state_backet
      "Description" = "S3 backet terraform"
    }
}
resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}