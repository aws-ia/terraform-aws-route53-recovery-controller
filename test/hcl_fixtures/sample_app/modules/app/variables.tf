variable "name" {
  default     = "tic-tac-toe"
  description = "test app variable"
  type        = string
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = 2
  type        = number
}

variable "alb_listener_port" {
  default     = 80
  type        = number
  description = "test app variable"
}

variable "app_port" {
  default     = 3000
  type        = number
  description = "test app variable"
}

variable "ddb" {
  description = "the ddb arn"
  type        = string
}

variable "allowed_ips" {
  description = "List of cidrs to allow communication to your app."
  type        = list(string)
}
