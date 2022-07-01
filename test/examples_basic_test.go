package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesBasic(t *testing.T) {

	sampleApp := &terraform.Options{
		TerraformDir: "./hcl_fixtures/sample_app",
		Vars: map[string]interface{}{
			"allowed_ips": []string{"127.0.0.1/32"},
		},
	}

	defer terraform.Destroy(t, sampleApp)
	terraform.InitAndApply(t, sampleApp)

	primary_asg_arn := terraform.Output(t, sampleApp, "asg_primary")
	primary_alb_arn := terraform.Output(t, sampleApp, "alb_primary")
	alternative_asg_arn := terraform.Output(t, sampleApp, "asg_alternative")
	alternative_alb_arn := terraform.Output(t, sampleApp, "alb_alternative")
	dynamodb := terraform.Output(t, sampleApp, "dynamodb_arn")

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]interface{}{
			"dynamodb_table_arn": dynamodb,
			"primary_app_arns": map[string]string{
				"autoscaling":          primary_asg_arn,
				"elasticloadbalancing": primary_alb_arn,
			},
			"alternative_app_arns": map[string]string{
				"autoscaling":          alternative_asg_arn,
				"elasticloadbalancing": alternative_alb_arn,
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
