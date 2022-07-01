variable "name" {
  type        = string
  description = "Name of your application."
  default     = "test"
}

variable "cells_definition" {
  type        = map(map(string))
  description = "Definition of the resources that makeup your Cell that you want monitored by ARC."
  default     = null
}

variable "hosted_zone" {
  description = "Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. Leave null to not create Route53 Alias records (required for LB functionality) ."

  type = object({
    name         = optional(string)
    private_zone = optional(bool)
    vpc_id       = optional(number)
    tags         = optional(map(string))
    zone_id      = optional(string)
  })

  default = {
    name    = null
    zone_id = null
  }
}

variable "create_recovery_cluster" {
  description = "Create the Routing Control Cluster and associated resources."
  type        = bool
  default     = false
}

variable "allowed_ips" {
  description = "List of cidrs to allow communication to your app."
  type        = list(string)
}

variable "primary_app_arns" {
  type        = any
  description = "Outputs passed to module for testing purposes (/test/example_basic_test.go)"
}

variable "alternative_app_arns" {
  type        = any
  description = "Outputs passed to module for testing purposes (/test/example_basic_test.go)"
}

variable "dynamodb_table_arn" {
  type        = string
  description = "(optional) describe your variable"
}
