variable "name" {
  description = "Name to prefix resources."
  type        = string
}

variable "cells_definition" {
  description = <<-EOF
  Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled are defined in `var.resource_type_name`. For examples, see the variables.tf file"
  /*
  cells_definition = {
    us-west-2 = {
      elasticloadbalancing = "arn:aws:elasticloadbalancing:us-west-2:<>:loadbalancer/app/<>"
      autoscaling          = "arn:aws:autoscaling:us-west-2:<>:autoScalingGroup:*:autoScalingGroupName/<>
    }
  }
  */
EOF

  type = map(map(string))
  validation {
    condition     = alltrue([for _, k in keys(var.cells_definition) : can(regex("[a-z][a-z]-[a-z]+-[1-9]", k))])
    error_message = "Keys(cells_definition) must be valid AWS Region names."
  }
}

variable "resource_type_name" {
  type        = map(string)
  description = "list of all service types you can pass and their associated Resource Set Type."

  default = {
    apigateway           = "AWS::ApiGatewayV2::Api"
    autoscaling          = "AWS::AutoScaling::AutoScalingGroup"
    cloudwatch           = "AWS::CloudWatch::Alarm"
    dynamodb             = "AWS::DynamoDB::Table"
    ec2-volume           = "AWS::EC2::Volume"
    ec2-vpc              = "AWS::EC2::VPC"
    ec2-vpn-gw           = "AWS::EC2::VPNGateway"
    ec2-vpn-cgw          = "AWS::EC2::CustomerGateway"
    ec2-vpn-conn         = "AWS::EC2::VPNConnection"
    elasticloadbalancing = "AWS::ElasticLoadBalancingV2::LoadBalancer"
    kafka                = "AWS::MSK::Cluster"
    lambda               = "AWS::Lambda::Function"
    rds                  = "AWS::RDS::DBCluster"
    route53              = "AWS::Route53::HealthCheck"
    sns                  = "AWS::SNS::Topic"
    sqs                  = "AWS::SQS::Queue"
  }
}

variable "safety_rule_type" {
  description = "Type of safety rules to create. Can only be \"assertion\" or \"gating\"."
  type        = string
  default     = "assertion"

  validation {
    condition     = var.safety_rule_type == lower("assertion") || var.safety_rule_type == lower("gating")
    error_message = "Safety rule type can only be \"assertion\" or \"gating\"."
  }
}

variable "safety_rules" {
  description = "Configuration of the Safety Rules. Key is the name applied to the rule."

  type = map(object({
    wait_period_ms = number
    inverted       = bool
    threshold      = number
    type           = string
    name_suffix    = string
  }))

  default = {
    MinCellsActive = {
      inverted       = false
      threshold      = 1
      type           = "ATLEAST"
      wait_period_ms = 5000
      name_suffix    = "MinCellsActive"
    }
  }
}

variable "hosted_zone" {
  description = "Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. Leave null to not create Route53 Alias records (required for LB functionality)."

  type = object({
    name         = optional(string)
    private_zone = optional(bool)
    vpc_id       = optional(string)
    tags         = optional(map(string))
    zone_id      = optional(string)
  })

  default = {
    name    = null
    zone_id = null
  }
}

variable "primary_cell_region" {
  description = "(Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set."
  type        = string
  default     = null

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.primary_cell_region)) || var.primary_cell_region == null
    error_message = "Must be a valid AWS region format."
  }
}

variable "create_recovery_cluster" {
  description = "Create the Routing Control Cluster and associated resources."
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be added to Readiness resources."
  default     = null
}
