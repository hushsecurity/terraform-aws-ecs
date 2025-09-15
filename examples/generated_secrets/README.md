# Upload Credentials Example – ECS Sensor Deployment

This example deploys the Hush ECS sensor service on EC2-backed ECS using the root Terraform module, and uploads new deployment and registry credentials to AWS Secrets Manager.

## What It Does

- Registers a daemon-mode ECS service (1 task per EC2 instance)
- Defines a task with `sensor` and `sensor-vector` containers
- Uploads credentials to Secrets Manager for deployment and registry access
- Creates a minimal ECS execution role with access to logs and secrets

## Usage

Create a `terraform.tfvars` file with the following:

```hcl
cluster_name                  = "your-ecs-cluster-name"

# Deployment credentials
deployment_token              = "your-deployment-token"
deployment_password           = "your-deployment-password"

# Container registry credentials
container_registry_username   = "your-registry-username"
container_registry_password   = "your-registry-password"

# AWSVPC networking (required - private subnets only)
vpc_private_subnets = [
  "subnet-xxxxxx",  # Private subnet A with NAT Gateway
  "subnet-yyyyyy",  # Private subnet B with NAT Gateway
  "subnet-zzzzzz"   # Private subnet C with NAT Gateway
]

# Option 1: Auto-create security group (recommended)
vpc_id = "vpc-xxxxxxxxx"  # Auto-creates egress-only security group

# Option 2: Use existing security groups (alternative to above)
# security_groups = ["sg-xxxxxxxxx"]  # Must allow egress traffic
````

Then run:

```bash
terraform init
terraform apply
```

**Note:** This will create AWS resources and may incur costs. Run `terraform destroy` to clean up.

## Requirements

| Name      | Version |
| --------- | ------- |
| Terraform | >= 1.0  |
| AWS       | >= 5.0  |
