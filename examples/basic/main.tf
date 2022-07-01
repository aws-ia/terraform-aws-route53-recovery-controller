module "basic_recovery_controller_example" {
  source = "../.."

  name                    = var.name
  create_recovery_cluster = var.create_recovery_cluster
  hosted_zone             = var.hosted_zone

  cells_definition = {
    us-east-1 = {
      autoscaling          = var.primary_app_arns["autoscaling"]
      elasticloadbalancing = var.primary_app_arns["elasticloadbalancing"]
      dynamodb             = var.dynamodb_table_arn
    }
    us-west-2 = {
      autoscaling          = var.alternative_app_arns["autoscaling"]
      elasticloadbalancing = var.alternative_app_arns["elasticloadbalancing"]
      dynamodb             = replace(var.dynamodb_table_arn, "us-east-1", "us-west-2")
    }
  }
}

# sample app is for demonstratino purposes only and is not safe for production workloads
# module "sample_app" {
#   source      = "../../test/hcl_fixtures/sample_app"
#   allowed_ips = var.allowed_ips
# }

# Regions must be hard coded for example since theyre defined explicitly in `cells_definition`
provider "aws" {
  region = "us-east-1"
}
