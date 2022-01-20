variable "name" {
  description = "Name to prefix resources."
  type        = string
}

variable "regions" {
  description = "List of regions that contain Cells to manage."
  type        = list(string)
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

variable "service_list" {
  description = "List of services that are being enabled. Names correspond with keys to `var.resource_type_name`."
  type        = list(string)
}

variable "resource_type_name" {
  type        = map(string)
  description = "list of all service types you can pass and their associated Resource Set Type."
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be added to Readiness resources."
  default     = null
}
