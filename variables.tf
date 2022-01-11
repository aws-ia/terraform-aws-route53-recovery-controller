variable "name" {
  description = "Name to prefix resources."
  type        = string
}

variable "cells_definition" {
  description = "Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled: `elasticloadbalancing`, `autoscaling`, `lambda`. Example below:"
  /*
  cells_definition = {
    us-west-2 = {
      elasticloadbalancing = "arn:aws:elasticloadbalancing:us-west-2:<>:loadbalancer/app/<>"
      autoscaling          = "arn:aws:autoscaling:us-west-2:<>:autoScalingGroup:*:autoScalingGroupName/<>
    }
  }
  */
  type = map(map(string))
  validation {
    condition = alltrue([for _, k in keys(var.cells_definition) : can(regex("[a-z][a-z]-[a-z]+-[1-9]", k))]) && alltrue(flatten([
      for arns in var.cells_definition : [
        for service, arn in arns : contains(["elasticloadbalancing", "autoscaling", "lambda", "apigateway", "kafka", "rds", "ec2", "route53", "sns", "sqs", "dynamodb"], service)
      ]
    ]))
    error_message = "Supported service names are elasticloadbalancing, autoscaling, lambda, apigateway, kafka, rds, ec2, route53, dynamodb, sns, or sqs."
  }
}

variable "global_table_arn" {
  description = "Dyanmodb Global Table if being used. Only need to pass for 1 region, will parse other region table arns."
  type        = string
  default     = null
}

variable "create_safety_rule_assertion" {
  description = "Whether or not to create an Assertion Saftey Rule"
  type        = bool
  default     = true
}

variable "safety_rule_assertion" {
  description = "Configuration of the Assertion Safety Rule"
  type = object({
    wait_period_ms = number
    inverted       = bool
    threshold      = number
    type           = string
    name_suffix    = string
  })
  default = {
    inverted       = false
    threshold      = 1
    type           = "ATLEAST"
    wait_period_ms = 5000
    name_suffix    = "MinCellsActive"
  }
}

variable "create_safety_rule_gating" {
  description = "Whether or not to create an Gating Saftey Rule"
  type        = bool
  default     = false
}

variable "safety_rule_gating" {
  description = "Configuration of the Gating Safety Rule"
  type = object({
    wait_period_ms = number
    inverted       = bool
    threshold      = number
    type           = string
    name_suffix    = string
  })
  default = null
}

variable "hosted_zone" {
  description = "Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided."
  type = object({
    name         = optional(string)
    private_zone = optional(bool)
    vpc_id       = optional(number)
    tags         = optional(map(string))
    zone_id      = optional(string)
  })
  default = null
}

variable "primary_cell_region" {
  description = "(Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. "
  type        = string
  default     = null
  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.primary_cell_region)) || var.primary_cell_region == null
    error_message = "Must be a valid AWS region format."
  }
}

variable "configure_route53_alias_records" {
  description = "If LBs are managed, determines if you want to create the requisite route53 alias records"
  type        = bool
  default     = true
}

variable "resource_type_name" {
  type        = map(string)
  description = "list of all service types you can pass and their associated Resource Set Type."
  default = {
    elasticloadbalancing = "AWS::ElasticLoadBalancingV2::LoadBalancer"
    autoscaling          = "AWS::AutoScaling::AutoScalingGroup"
    lambda               = "AWS::Lambda::Function"
    dynamodb             = "AWS::DynamoDB::Table"
    sqs                  = "AWS::SQS::Queue"
    sns                  = "AWS::SNS::Topic"
    ec2                  = "AWS::EC2::VPC"
    route53              = "AWS::Route53::HealthCheck"
    cloudwatch           = "AWS::CloudWatch::Alarm"
    rds                  = "AWS::RDS::DBCluster"
    apigateway           = "AWS::ApiGatewayV2::Api"
    kafka                = "AWS::MSK::Cluster"
    // ec2 AWS::EC2::VPNGateway
    // ec2 AWS::EC2::VPNConnection
    // ec2 AWS::EC2::CustomerGateway
    // ec2 AWS::EC2::Volume
    // apigateway v1?
  }
}
