variable "name" {
  default = "tic-tac-toe"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "alb_listener_port" {
  default = 80
}

variable "app_port" {
  default = 3000
}
