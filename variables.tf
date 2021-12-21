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
