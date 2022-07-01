data "aws_region" "current" {}

#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "app_source_code" {
  bucket_prefix = "${var.app_name}-source-code-"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "app_source_code" {
  bucket = aws_s3_bucket.app_source_code.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "app_source_code" {
  bucket = aws_s3_bucket.app_source_code.id
  key    = "${var.app_name}.zip"
  source = "${path.root}/.archive_files/${var.app_name}.zip"
}

#tfsec:ignore:aws-dynamodb-enable-recovery tfsec:ignore:aws-dynamodb-table-customer-key
resource "aws_dynamodb_table" "global" {
  name             = var.app_name
  hash_key         = "email"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "email"
    type = "S"
  }

  replica {
    region_name = var.alternative_region
  }

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

module "app_primary" {
  source      = "./modules/app"
  ddb         = aws_dynamodb_table.global.arn
  allowed_ips = var.allowed_ips
}

module "app_alternative" {
  source      = "./modules/app"
  ddb         = aws_dynamodb_table.global.arn
  allowed_ips = var.allowed_ips

  providers = {
    aws = aws.alternative
  }
}

