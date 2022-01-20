variable "name" {
  description = "Name to prefix resources."
  type        = string
}

variable "regions" {
  description = "List of regions that contain Cells to manage."
  type        = list(string)
}

variable "safety_rule_type" {
  description = "Type of safety rules to create. Can only be \"assertion\" or \"gating\"."
  type        = string
  default     = "assertion"
  validation {
    condition     = var.safety_rule_type == lower("assertion") || var.safety_rule_type == lower("gating")
    error_message = "Safety rule type can only be assertion or gating."
  }
}

variable "safety_rules" {
  description = "Configuration of the Safety Rules"
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
  description = "Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided."
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

variable "primary_cell_region" {
  description = "(Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. "
  type        = string
  default     = null
  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.primary_cell_region)) || var.primary_cell_region == null
    error_message = "Must be a valid AWS region format."
  }
}

variable "lb_info" {
  type        = any
  description = "Map of lb info from each region declared."
}

variable "cells_definition" {
  description = "Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled are defined in `var.resource_type_name`. Example below:"
  /*
  cells_definition = {
    us-west-2 = {
      elasticloadbalancing = "arn:aws:elasticloadbalancing:us-west-2:<>:loadbalancer/app/<>"
      autoscaling          = "arn:aws:autoscaling:us-west-2:<>:autoScalingGroup:*:autoScalingGroupName/<>
    }
  }
  */
  type = map(map(string))
  # validation {} removed to reduce complexity when adding a new service, validation enforced via Root Module.
}
