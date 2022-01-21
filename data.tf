locals {
  configure_lbs = contains(local.service_list, "elasticloadbalancing")

  lb_info = merge({
    us-east-1      = one(data.aws_lb.us_east_1)
    us-east-2      = one(data.aws_lb.us_east_2)
    us-west-1      = one(data.aws_lb.us_west_1)
    us-west-2      = one(data.aws_lb.us_west_2)
    ca-central-1   = one(data.aws_lb.ca_central_1)
    ap-south-1     = one(data.aws_lb.ap_south_1)
    ap-northeast-2 = one(data.aws_lb.ap_northeast_2)
    ap-southeast-1 = one(data.aws_lb.ap_southeast_1)
    ap-southeast-2 = one(data.aws_lb.ap_southeast_2)
    ap-northeast-1 = one(data.aws_lb.ap_northeast_1)
    eu-central-1   = one(data.aws_lb.eu_central_1)
    eu-west-1      = one(data.aws_lb.eu_west_1)
    eu-west-2      = one(data.aws_lb.eu_west_2)
    eu-west-3      = one(data.aws_lb.eu_west_3)
    eu-north-1     = one(data.aws_lb.eu_north_1)
    sa-east-1      = one(data.aws_lb.sa_east_1)
    ap-northeast-3 = one(data.aws_lb.ap_northeast_3)
    ap-south-1     = one(data.aws_lb.ap_south_1)
  })
}

data "aws_lb" "us_east_1" {
  count    = local.configure_lbs && contains(local.regions, "us-east-1") ? 1 : 0
  provider = aws.us-east-1

  arn = var.cells_definition["us-east-1"].elasticloadbalancing
}

data "aws_lb" "us_west_2" {
  count    = local.configure_lbs && contains(local.regions, "us-west-2") ? 1 : 0
  provider = aws.us-west-2

  arn = var.cells_definition["us-west-2"].elasticloadbalancing
}

data "aws_lb" "us_east_2" {
  count    = local.configure_lbs && contains(local.regions, "us-east-2") ? 1 : 0
  provider = aws.us-east-2

  arn = var.cells_definition["us-east-2"].elasticloadbalancing
}

data "aws_lb" "us_west_1" {
  count    = local.configure_lbs && contains(local.regions, "us-west-1") ? 1 : 0
  provider = aws.us-west-1

  arn = var.cells_definition["us-west-1"].elasticloadbalancing
}

data "aws_lb" "ca_central_1" {
  count    = local.configure_lbs && contains(local.regions, "ca-central-1") ? 1 : 0
  provider = aws.ca-central-1

  arn = var.cells_definition["ca-central-1"].elasticloadbalancing
}

data "aws_lb" "ap_south_1" {
  count    = local.configure_lbs && contains(local.regions, "ap-south-1") ? 1 : 0
  provider = aws.ap-south-1

  arn = var.cells_definition["ap-south-1"].elasticloadbalancing
}

data "aws_lb" "ap_northeast_3" {
  count    = local.configure_lbs && contains(local.regions, "ap-northeast-3") ? 1 : 0
  provider = aws.ap-northeast-3

  arn = var.cells_definition["ap-northeast-3"].elasticloadbalancing
}

data "aws_lb" "ap_northeast_2" {
  count    = local.configure_lbs && contains(local.regions, "ap-northeast-2") ? 1 : 0
  provider = aws.ap-northeast-2

  arn = var.cells_definition["ap-northeast-2"].elasticloadbalancing
}

data "aws_lb" "ap_northeast_1" {
  count    = local.configure_lbs && contains(local.regions, "ap-northeast-1") ? 1 : 0
  provider = aws.ap-northeast-1

  arn = var.cells_definition["ap-northeast-1"].elasticloadbalancing
}

data "aws_lb" "ap_southeast_1" {
  count    = local.configure_lbs && contains(local.regions, "ap-southeast-1") ? 1 : 0
  provider = aws.ap-southeast-1

  arn = var.cells_definition["ap-southeast-1"].elasticloadbalancing
}

data "aws_lb" "ap_southeast_2" {
  count    = local.configure_lbs && contains(local.regions, "ap-southeast-2") ? 1 : 0
  provider = aws.ap-southeast-2

  arn = var.cells_definition["ap-southeast-2"].elasticloadbalancing
}

data "aws_lb" "eu_central_1" {
  count    = local.configure_lbs && contains(local.regions, "eu-central-1") ? 1 : 0
  provider = aws.eu-central-1

  arn = var.cells_definition["eu-central-1"].elasticloadbalancing
}

data "aws_lb" "eu_west_1" {
  count    = local.configure_lbs && contains(local.regions, "eu-west-1") ? 1 : 0
  provider = aws.eu-west-1

  arn = var.cells_definition["eu-west-1"].elasticloadbalancing
}

data "aws_lb" "eu_west_2" {
  count    = local.configure_lbs && contains(local.regions, "eu-west-2") ? 1 : 0
  provider = aws.eu-west-2

  arn = var.cells_definition["eu-west-2"].elasticloadbalancing
}

data "aws_lb" "eu_west_3" {
  count    = local.configure_lbs && contains(local.regions, "eu-west-3") ? 1 : 0
  provider = aws.eu-west-3

  arn = var.cells_definition["eu-west-3"].elasticloadbalancing
}

data "aws_lb" "eu_north_1" {
  count    = local.configure_lbs && contains(local.regions, "eu-north-1") ? 1 : 0
  provider = aws.eu-north-1

  arn = var.cells_definition["eu-north-1"].elasticloadbalancing
}

data "aws_lb" "sa_east_1" {
  count    = local.configure_lbs && contains(local.regions, "sa-east-1") ? 1 : 0
  provider = aws.sa-east-1

  arn = var.cells_definition["sa-east-1"].elasticloadbalancing
}
