variable "regions" {
  description = ""
  type = list(string)
}

variable "name" {
  description = ""
  type = string
}

variable "cell_attributes" {
  type = map(object({
    alb = optional(string)
    asg = optional(string)
  }))
  default = {
    us-east-1 = {
        alb = "arn:aws:elasticloadbalancing:us-east-1:293350688343:loadbalancer/app/Ticta-TicTa-FE472IBS7IWI/ada2087582d6438d"
        asg = "arn:aws:autoscaling:us-east-1:293350688343:autoScalingGroup:*:autoScalingGroupName/TictactoeAppCdkStack-us-east-1-TicTacToeASGCBDED12E-16WLMC3YYKQI7"

    }
    us-west-2 = {
        alb = "arn:aws:elasticloadbalancing:us-west-2:293350688343:loadbalancer/app/Ticta-TicTa-1FWKSP3NZM899/fd7b7beb1b0b5a13"
        asg = "arn:aws:autoscaling:us-west-2:293350688343:autoScalingGroup:*:autoScalingGroupName/TictactoeAppCdkStack-us-west-2-TicTacToeASGCBDED12E-KZA40NX503CB"
    }
  }
}

variable "global_table_arn" {
  type = string
}
