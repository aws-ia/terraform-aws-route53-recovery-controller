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
  // validation {} removed to reduce complexity when adding a new service, validation enforced via Root Module.
}

variable "service_list" {

}

variable "resource_type_name" {

}
