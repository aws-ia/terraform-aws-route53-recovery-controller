variable "name" {
  description = "Name to prefix resources."
  type        = string
}

variable "cell_attributes" {
  description = "Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled: `elasticloadbalancing`, `autoscaling`, `lambda`. Example below:"
  /*
  cell_attributes = {
    us-west-2 = {
      elasticloadbalancing = "arn:aws:elasticloadbalancing:us-west-2:<>:loadbalancer/app/<>"
      autoscaling          = "arn:aws:autoscaling:us-west-2:<>:autoScalingGroup:*:autoScalingGroupName/<>
    }
  }
  */
  type = map(object({
    elasticloadbalancing = optional(string)
    autoscaling          = optional(string)
    lambda               = optional(string)
  }))
}

variable "global_table_arn" {
  description = "Dyanmodb Global Table if being used. Only need to pass for 1 region, will parse other region table arns."
  type        = string
  default     = null
}

variable "create_safety_rule_assertion" {
  description = "Whether or not to create an Assertion Saftey Rule"
  type    = bool
  default = true
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
  type    = bool
  default = false
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
  type    = string
  default = null
  validation {
    condition = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.primary_cell_region))
    error_message = "Must be a valid AWS region format."
  }
}

variable "configure_route53_alias_records" {
  description = "If LBs are managed, determines if you want to create the requisite route53 alias records"
  type = bool
  default = true
}
