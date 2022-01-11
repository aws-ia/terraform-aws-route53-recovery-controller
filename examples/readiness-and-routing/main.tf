module "arc" {
  source = "../.."

  name = "test"
  cells_definition = {
    us-east-1 = {
      elasticloadbalancing = "arn:aws:elasticloadbalancing:us-east-1:293350688343:loadbalancer/app/Ticta-TicTa-FE472IBS7IWI/ada2087582d6438d"
      autoscaling          = "arn:aws:autoscaling:us-east-1:293350688343:autoScalingGroup:*:autoScalingGroupName/TictactoeAppCdkStack-us-east-1-TicTacToeASGCBDED12E-16WLMC3YYKQI7"
      dynamodb             = "arn:aws:dynamodb:us-east-1:293350688343:table/Games"
    }
    us-west-2 = {
      elasticloadbalancing = "arn:aws:elasticloadbalancing:us-west-2:293350688343:loadbalancer/app/Ticta-TicTa-1FWKSP3NZM899/fd7b7beb1b0b5a13"
      autoscaling          = "arn:aws:autoscaling:us-west-2:293350688343:autoScalingGroup:*:autoScalingGroupName/TictactoeAppCdkStack-us-west-2-TicTacToeASGCBDED12E-KZA40NX503CB"
      dynamodb             = "arn:aws:dynamodb:us-west-2:293350688343:table/Games"
    }
  }
  hosted_zone = {
    name         = "gtphonehome.com."
    private_zone = true
  }
}
