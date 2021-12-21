variable "name" {
  description = ""
  type = string
}

variable "cell_attributes" {
  type = map(object({
    alb = optional(string)
    asg = optional(string)
  }))
}

variable "global_table_arn" {
  type = string
}
