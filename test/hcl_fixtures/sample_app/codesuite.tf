# Codebuild role

resource "aws_iam_role" "codebuild_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  path               = "/"
}

resource "aws_iam_policy" "codebuild_policy" {
  description = "Policy to allow codebuild to execute build spec"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.artifact_bucket_region_1.arn}/*", "${aws_s3_bucket.artifact_bucket_region_1.arn}"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}


# Codebuild project

resource "aws_codebuild_project" "codebuild" {

  name         = "codebuild-code"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = <<BUILDSPEC
version: 0.2
phases:
  install:
    runtime-versions:
      nodejs: 12
  build:
    commands:
      - echo Build started on `date`
      - echo Installing source NPM dependencies...
      - npm install
      - npm audit fix
  post_build:
    commands:
      - echo Build completed on `date`
artifacts:
    files:
      - '**/*'
    name: arc-build-$(date +%Y-%m-%d)
BUILDSPEC
  }
}

# create a service role for codedeploy
resource "aws_iam_role" "codedeploy_service" {
  name_prefix = "codedeploy-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach AWS managed policy called AWSCodeDeployRole
# required for deployments which are to an EC2 compute platform
resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = aws_iam_role.codedeploy_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# create a CodeDeploy application
resource "aws_codedeploy_app" "main" {
  name = "ARC_App"
}

# create a deployment group
resource "aws_codedeploy_deployment_group" "main" {
  app_name              = aws_codedeploy_app.main.name
  deployment_group_name = "ARC_Deployment_Group"
  service_role_arn      = aws_iam_role.codedeploy_service.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime" # AWS defined deployment config

  autoscaling_groups = [module.app_primary.asg.name]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = "${var.app_name}-tgrp"
    }
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "ARC_App"
    }
  }

  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
}


# create a CodeDeploy application
resource "aws_codedeploy_app" "app_region_2" {
  provider = aws.alternative
  name     = "ARC_App"
}


# create a deployment group
resource "aws_codedeploy_deployment_group" "deployment_group_region_2" {
  provider = aws.alternative

  app_name              = aws_codedeploy_app.app_region_2.name
  deployment_group_name = "ARC_Deployment_Group"
  service_role_arn      = aws_iam_role.codedeploy_service.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime" # AWS defined deployment config

  autoscaling_groups = [module.app_alternative.asg.name]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }


  load_balancer_info {
    target_group_info {
      name = "${var.app_name}-tgrp"
    }
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "ARC_App"
    }
  }

  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
}

# Codepipeline role

resource "aws_iam_role" "codepipeline_role" {
  depends_on = [aws_s3_bucket.artifact_bucket_region_1, aws_s3_bucket.artifact_bucket_region_2]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  path               = "/"
}

resource "aws_iam_policy" "codepipeline_policy" {
  description = "Policy to allow codepipeline to execute"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DescribeBucket"
      ],
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.artifact_bucket_region_1.arn}/*",
                    "${aws_s3_bucket.artifact_bucket_region_1.arn}",
                    "${aws_s3_bucket.artifact_bucket_region_2.arn}/*",
                    "${aws_s3_bucket.artifact_bucket_region_2.arn}",
                    "${aws_s3_bucket.app_source_code.arn}/*",
                    "${aws_s3_bucket.app_source_code.arn}"]
    },
    {
      "Action" : [
        "iam:PassRole",
        "codebuild:StartBuild",
        "codebuild:BatchGetBuilds"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "codedeploy:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.name

  depends_on = [aws_iam_policy.codepipeline_policy, aws_iam_role.codepipeline_role]

}

#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "artifact_bucket_region_1" {
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "s3_region_1_public_block" {
  bucket = aws_s3_bucket.artifact_bucket_region_1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "artifact_bucket_region_2" {
  provider = aws.alternative

  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "s3_region_2_public_block" {
  provider = aws.alternative

  bucket = aws_s3_bucket.artifact_bucket_region_2.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_codepipeline" "pipeline" {

  name     = "ARC-Pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  depends_on = [aws_iam_role_policy_attachment.codepipeline_attach]

  artifact_store {
    location = aws_s3_bucket.artifact_bucket_region_1.bucket
    type     = "S3"
    region   = data.aws_region.current.name
  }

  artifact_store {
    location = aws_s3_bucket.artifact_bucket_region_2.bucket
    type     = "S3"
    region   = var.alternative_region
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "S3"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        S3Bucket             = aws_s3_bucket.app_source_code.id
        S3ObjectKey          = "${var.app_name}.zip"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild.id
      }
    }
  }

  stage {
    name = "Deploy-to-Region-1"
    action {
      region          = data.aws_region.current.name
      name            = "Deploy-to-Region-1"
      category        = "Deploy"
      owner           = "AWS"
      version         = "1"
      provider        = "CodeDeploy"
      run_order       = 1
      input_artifacts = ["BuildOutput"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.main.name
        DeploymentGroupName = aws_codedeploy_deployment_group.main.deployment_group_name
      }
    }
  }


  stage {
    name = "Manual-Approval"

    action {
      category = "Approval"
      name     = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }


  stage {
    name = "Deploy-to-Region-2"
    action {
      region          = var.alternative_region
      name            = "Deploy-to-Region-2"
      category        = "Deploy"
      owner           = "AWS"
      version         = "1"
      provider        = "CodeDeploy"
      run_order       = 1
      input_artifacts = ["BuildOutput"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.app_region_2.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group_region_2.deployment_group_name
      }
    }
  }
}
