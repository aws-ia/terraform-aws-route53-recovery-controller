variable "alternative_region" {
  description = "The Alternative AWS region to deploy app to."
  default     = "us-west-2"
  type        = string
}

variable "app_name" {
  default     = "tic-tac-toe"
  description = "test app variable"
  type        = string
}

variable "allowed_ips" {
  description = "List of cidrs to allow communication to your app."
  type        = list(string)
}
