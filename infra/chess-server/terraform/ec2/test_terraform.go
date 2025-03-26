package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformChessInfra(t *testing.T) {
	options := &terraform.Options{
		TerraformDir: "../terraform",
	}

	// Init et apply
	terraform.InitAndApply(t, options)

	// Vérification que l'instance EC2 existe
	instanceID := terraform.Output(t, options, "instance_id")
	assert.NotEmpty(t, instanceID, "L'ID de l'instance EC2 ne doit pas être vide")

	// Vérification du Load Balancer
	albDNS := terraform.Output(t, options, "alb_dns")
	assert.Contains(t, albDNS, "elb.amazonaws.com", "L'ALB doit être un ELB AWS")

	// Destroy après le test
	defer terraform.Destroy(t, options)
}
