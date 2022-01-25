data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

resource "aws_iam_role" "app_role" {
  name_prefix        = "${var.name}-${data.aws_region.current.name}-app"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [aws_iam_policy.dynamodb_rw_policy.arn, "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "dynamodb_rw_policy" {
  name = "${var.name}-${data.aws_region.current.name}-dynamodb_rw_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:*"] #tfsec:ignore:aws-iam-no-policy-wildcards
        Effect   = "Allow"
        Resource = [var.ddb]
      },
    ]
  })
}


resource "aws_iam_instance_profile" "app" {
  name = "${var.name}-${data.aws_region.current.name}"
  role = aws_iam_role.app_role.name
}

resource "aws_launch_configuration" "launch_conf" {
  name          = var.name
  image_id      = data.aws_ami.al2.id
  instance_type = "t4g.micro"

  root_block_device {
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.app.name
  security_groups      = [aws_security_group.asg.id]

  user_data = <<-EOF
              #!/bin/bash -x
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

              # Install dependencies
              echo "Installing dependencies"
              sleep 60

              sudo yum -y update
              sudo yum install -y aws-cli ruby jq
              sudo yum install -y wget

              # Set REGION environment variables for the CodeDeploy agent and the NodeJS app
              echo "Setting REGION variable"

              cd /home/ec2-user
              echo 'export REGION="${data.aws_region.current.name}"' >> .bashrc

              ## Code Deploy Agent Bootstrap Script ##

              #To clean the AMI of any previous agent caching information, run the following script:
              echo "Deleting CodeDeploy agent"

              CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
              $CODEDEPLOY_BIN stop
              sudo yum erase codedeploy-agent -y

              # Install CodeDeploy agent
              echo "Installing CodeDeploy agent"
              cd /home/ec2-user
              wget https://aws-codedeploy-${data.aws_region.current.name}.s3.${data.aws_region.current.name}.amazonaws.com/latest/install
              sudo chmod +x ./install
              if ./install auto; then
                  echo "CodeDeploy Agent: Installation completed"
                  exit 0
              else
                  echo "CodeDeploy Agent: Installation script failed, please investigate"
                  exit 1
              fi

              EOF
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = var.name
  launch_configuration      = aws_launch_configuration.launch_conf.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 30
  health_check_type         = "ELB"
  vpc_zone_identifier       = aws_subnet.private.*.id
  tag {
    key                 = "Name"
    value               = "ARC_App"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow connections from user specified ip"
    protocol    = "tcp"
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    cidr_blocks = var.allowed_ips
  }

  egress {
    description = "sample app"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sg
  }
  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "asg" {
  name        = "${var.name}-asg"
  vpc_id      = aws_vpc.main.id
  description = "sg for asg"

  ingress {
    description     = "sample app"
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "sample app"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sg
  }
  tags = {
    Name = var.name
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.name
  }
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = element(aws_subnet.public.*.id, 0)
  allocation_id = aws_eip.eip.id
  tags = {
    Name = var.name
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-PublicSubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-PrivateRouteTable"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-PublicRouteTable"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

  depends_on = [aws_nat_gateway.nat]

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_alb" "alb" {
  name                       = "${var.name}-${data.aws_region.current.name}"
  internal                   = false #tfsec:ignore:aws-elbv2-alb-not-public
  load_balancer_type         = "application"
  drop_invalid_header_fields = true

  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "trgp" {
  name                 = var.name
  port                 = var.app_port
  protocol             = "HTTP" #tfsec:ignore:aws-elbv2-http-not-used
  vpc_id               = aws_vpc.main.id
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    enabled           = "true"
    healthy_threshold = 3
    interval          = 5
    timeout           = 3
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 3600
    enabled         = "true"
  }

}

resource "aws_alb_listener" "app" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.alb_listener_port
  protocol          = "HTTP" #tfsec:ignore:aws-elbv2-http-not-used

  default_action {
    target_group_arn = aws_alb_target_group.trgp.id
    type             = "forward"
  }
}

