data "aws_region" "current" {}

data "aws_route53_zone" "main" {
  count = var.hosted_zone.zone_id == null ? 1 : 0

  name         = var.hosted_zone.name
  private_zone = var.hosted_zone.private_zone
  vpc_id       = var.hosted_zone.vpc_id
  tags         = var.hosted_zone.tags
}

locals {
  lb_info = merge({
    us-east-1      = one(data.aws_lb.us-east-1)
    us-east-2      = one(data.aws_lb.us-east-2)
    us-west-1      = one(data.aws_lb.us-west-1)
    us-west-2      = one(data.aws_lb.us-west-2)
    ca-central-1   = one(data.aws_lb.ca-central-1)
    ap-south-1     = one(data.aws_lb.ap-south-1)
    ap-northeast-2 = one(data.aws_lb.ap-northeast-2)
    ap-southeast-1 = one(data.aws_lb.ap-southeast-1)
    ap-southeast-2 = one(data.aws_lb.ap-southeast-2)
    ap-northeast-1 = one(data.aws_lb.ap-northeast-1)
    eu-central-1   = one(data.aws_lb.eu-central-1)
    eu-west-1      = one(data.aws_lb.eu-west-1)
    eu-west-2      = one(data.aws_lb.eu-west-2)
    eu-west-3      = one(data.aws_lb.eu-west-3)
    eu-north-1     = one(data.aws_lb.eu-north-1)
    sa-east-1      = one(data.aws_lb.sa-east-1)
    ap-northeast-3 = one(data.aws_lb.ap-northeast-3)
    ap-south-1     = one(data.aws_lb.ap-south-1)
  })
}

data "aws_lb" "us-east-1" {
  count    = local.config_lbs && contains(local.regions, "us-east-1") ? 1 : 0
  provider = aws.us-east-1

  arn = var.cell_attributes["us-east-1"].elasticloadbalancing
}

data "aws_lb" "us-west-2" {
  count    = local.config_lbs && contains(local.regions, "us-west-2") ? 1 : 0
  provider = aws.us-west-2

  arn = var.cell_attributes["us-west-2"].elasticloadbalancing
}

data "aws_lb" "us-east-2" {
  count    = local.config_lbs && contains(local.regions, "us-east-2") ? 1 : 0
  provider = aws.us-east-2

  arn = var.cell_attributes["us-east-2"].elasticloadbalancing
}

data "aws_lb" "us-west-1" {
  count    = local.config_lbs && contains(local.regions, "us-west-1") ? 1 : 0
  provider = aws.us-west-1

  arn = var.cell_attributes["us-west-1"].elasticloadbalancing
}

data "aws_lb" "ca-central-1" {
  count    = local.config_lbs && contains(local.regions, "ca-central-1") ? 1 : 0
  provider = aws.ca-central-1

  arn = var.cell_attributes["ca-central-1"].elasticloadbalancing
}

data "aws_lb" "ap-south-1" {
  count    = local.config_lbs && contains(local.regions, "ap-south-1") ? 1 : 0
  provider = aws.ap-south-1

  arn = var.cell_attributes["ap-south-1"].elasticloadbalancing
}

data "aws_lb" "ap-northeast-3" {
  count    = local.config_lbs && contains(local.regions, "ap-northeast-3") ? 1 : 0
  provider = aws.ap-northeast-3

  arn = var.cell_attributes["ap-northeast-3"].elasticloadbalancing
}

data "aws_lb" "ap-northeast-2" {
  count    = local.config_lbs && contains(local.regions, "ap-northeast-2") ? 1 : 0
  provider = aws.ap-northeast-2

  arn = var.cell_attributes["ap-northeast-2"].elasticloadbalancing
}

data "aws_lb" "ap-northeast-1" {
  count    = local.config_lbs && contains(local.regions, "ap-northeast-1") ? 1 : 0
  provider = aws.ap-northeast-1

  arn = var.cell_attributes["ap-northeast-1"].elasticloadbalancing
}

data "aws_lb" "ap-southeast-1" {
  count    = local.config_lbs && contains(local.regions, "ap-southeast-1") ? 1 : 0
  provider = aws.ap-southeast-1

  arn = var.cell_attributes["ap-southeast-1"].elasticloadbalancing
}

data "aws_lb" "ap-southeast-2" {
  count    = local.config_lbs && contains(local.regions, "ap-southeast-2") ? 1 : 0
  provider = aws.ap-southeast-2

  arn = var.cell_attributes["ap-southeast-2"].elasticloadbalancing
}


data "aws_lb" "eu-central-1" {
  count    = local.config_lbs && contains(local.regions, "eu-central-1") ? 1 : 0
  provider = aws.eu-central-1

  arn = var.cell_attributes["eu-central-1"].elasticloadbalancing
}

data "aws_lb" "eu-west-1" {
  count    = local.config_lbs && contains(local.regions, "eu-west-1") ? 1 : 0
  provider = aws.eu-west-1

  arn = var.cell_attributes["eu-west-1"].elasticloadbalancing
}

data "aws_lb" "eu-west-2" {
  count    = local.config_lbs && contains(local.regions, "eu-west-2") ? 1 : 0
  provider = aws.eu-west-2

  arn = var.cell_attributes["eu-west-2"].elasticloadbalancing
}

data "aws_lb" "eu-west-3" {
  count    = local.config_lbs && contains(local.regions, "eu-west-3") ? 1 : 0
  provider = aws.eu-west-3

  arn = var.cell_attributes["eu-west-3"].elasticloadbalancing
}

data "aws_lb" "eu-north-1" {
  count    = local.config_lbs && contains(local.regions, "eu-north-1") ? 1 : 0
  provider = aws.eu-north-1

  arn = var.cell_attributes["eu-north-1"].elasticloadbalancing
}

data "aws_lb" "sa-east-1" {
  count    = local.config_lbs && contains(local.regions, "sa-east-1") ? 1 : 0
  provider = aws.sa-east-1

  arn = var.cell_attributes["sa-east-1"].elasticloadbalancing
}
