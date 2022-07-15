resource "aws_route53recoveryreadiness_cell" "primary_cell" {
  cell_name = "us-east-1-primary-cell"
  cells     = [for _, v in module.primary.cells : v.arn]
}

resource "aws_route53recoveryreadiness_cell" "failover_cell" {
  cell_name = "us-west-2-failover-cell"
  cells     = [for _, v in module.failover.cells : v.arn]
}

resource "aws_route53recoveryreadiness_recovery_group" "all_regions" {
  recovery_group_name = var.name
  cells               = [aws_route53recoveryreadiness_cell.primary_cell.arn, aws_route53recoveryreadiness_cell.failover_cell.arn]
  tags                = var.tags
}

module "primary" {
  source = "../.."

  name                    = "${var.name}-primary"
  create_recovery_cluster = false
  hosted_zone             = var.hosted_zone
  create_recovery_group   = false

  cells_definition = {
    us-east-1a = {
      autoscaling          = module.sample_app.asg_primary.arn
      elasticloadbalancing = module.sample_app.alb_primary.arn
    }
    us-east-1b = {
      autoscaling          = "<>"
      elasticloadbalancing = "<>"

    }
  }
}

module "failover" {
  source = "../.."

  name                    = "${var.name}-failover"
  create_recovery_cluster = false
  hosted_zone             = var.hosted_zone
  create_recovery_group   = false

  cells_definition = {
    us-west-2a = {
      autoscaling          = module.sample_app.asg_primary.arn
      elasticloadbalancing = module.sample_app.alb_primary.arn
    }
    us-west-2b = {
      autoscaling          = "<>"
      elasticloadbalancing = "<>"

    }
  }
}
