variable "name" {
  description = "Name to prefix resources."
  type        = string
}

variable "regions" {
  description = "List of regions that contain Cells to manage."
  type        = list(string)
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

// can we move providers to this module?
variable "lb_info" {
  type        = any
  description = "Map of lb info from each region declared."
}

// still necessary?
variable "configure_lbs" {
  type        = bool
  description = "Whether or not to define LBs"
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
  // validation {} removed to reduce complexity when adding a new service, validation enforced via Root Module.
}

variable "create_r53_records" {
  default = false
}
