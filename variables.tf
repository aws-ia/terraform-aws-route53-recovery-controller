variable "name" {
  description = ""
  type = string
}

variable "cell_attributes" {
  type = map(object({
    lb = optional(string)
    asg = optional(string)
  }))
}

variable "global_table_arn" {
  type = string
  default = null
}

variable "create_safety_rule_assertion" {
  type = number
  default = 1
  validation {
    condition = can(regex("0|1", var.create_safety_rule_assertion))
    error_message = "Must be either 0 or 1."
  }
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
    inverted = false
    threshold = 1
    type = "ATLEAST"
    wait_period_ms = 5000
    name_suffix = "MinCellsActive"
  }
}

variable "create_safety_rule_gating" {
  type = number
  default = 0
  validation {
    condition = can(regex("0|1", var.create_safety_rule_gating))
    error_message = "Must be either 0 or 1."
  }
}

variable "safety_rule_gating" {
  type = object({
    wait_period_ms = number
    inverted       = bool
    threshold      = number
    type           = string
    name_suffix    = string
  })
  default = {
    inverted = false
    threshold = 1
    type = "ATLEAST"
    wait_period_ms = 5000
    name_suffix = "MinCellsActive"
  }
}
