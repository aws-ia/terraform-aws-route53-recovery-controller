variable "name" {
  description = ""
  type        = string
}

variable "cell_attributes" {
  type = map(object({
    elasticloadbalancing = optional(string)
    autoscaling          = optional(string)
  }))
}

variable "global_table_arn" {
  type    = string
  default = null
}

variable "create_safety_rule_assertion" {
  type    = bool
  default = true
}

variable "safety_rule_assertion" {
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
  type    = bool
  default = false
}

variable "safety_rule_gating" {
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
  type    = string
  default = null
}
