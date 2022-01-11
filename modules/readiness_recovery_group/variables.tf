variable "name" {
  description = "Name to prefix resources."
  type        = string
}


variable "regions" {
  description = "List of regions that contain Cells to manage."
  type        = list(string)
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

variable "service_list" {

}

variable "resource_type_name" {

}
