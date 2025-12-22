# Generated Secrets Example

Deploy Hush ECS services and **automatically create AWS Secrets Manager secrets** from provided credentials.

## Quick Start

1. **Edit `terraform.tfvars`** with your configuration:

```hcl
cluster_name = "your-ecs-cluster-name"

deployment_token    = "your-deployment-token"
deployment_password = "your-deployment-password"

container_registry_username = "your-registry-username"
container_registry_password = "your-registry-password"

vpc_private_subnets = ["subnet-xxx", "subnet-yyy", "subnet-zzz"]
vpc_id              = "vpc-xxxxxxxxxxxxxxxxx"
```

2. **Deploy:**

```bash
terraform init
terraform apply
```

3. **Clean up:**

```bash
terraform destroy
```

## What Gets Created

- ✅ Hush sensor ECS service (daemon mode - 1 per EC2 instance)
- ✅ Hush Vermon ECS service (auto-upgrade component)
- ✅ ECS task definitions with sensor and vector containers
- ✅ **AWS Secrets Manager secrets** (created from your credentials)
- ✅ Security group (egress-only, auto-created)
- ✅ IAM roles for ECS task execution

## How It Works

The module creates two AWS Secrets Manager secrets:

1. **Deployment credentials** - Contains `deployment_token` and `deployment_password`
2. **Registry credentials** - Contains container registry `username` and `password`

These secrets are securely injected into ECS task containers at runtime.

## Requirements

- Terraform >= 1.3
- AWS provider >= 5.0
- ECS cluster (EC2-backed)
- Private subnets with NAT Gateway
- Valid Hush deployment credentials

| Name      | Version |
| --------- | ------- |
| Terraform | >= 1.0  |
| AWS       | >= 5.0  |
