# Existing Secrets Example

Deploy Hush ECS services using **existing AWS Secrets Manager secrets** for credentials.

## Quick Start

1. **Edit `terraform.tfvars`** with your AWS resources:

```hcl
cluster_name = "your-ecs-cluster-name"

deployment_credentials_secret_arn         = "arn:aws:secretsmanager:region:account-id:secret:hush-deployment-creds-XXXXXX"
container_registry_credentials_secret_arn = "arn:aws:secretsmanager:region:account-id:secret:hush-registry-creds-XXXXXX"

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

## Secret Format Requirements

**Deployment credentials secret** (JSON):
```json
{
  "deployment_token": "your-token",
  "deployment_password": "your-password"
}
```

**Container registry credentials secret** (JSON):
```json
{
  "username": "your-username",
  "password": "your-password"
}
```

## What Gets Created

- ✅ Hush sensor ECS service (daemon mode - 1 per EC2 instance)
- ✅ Hush Vermon ECS service (auto-upgrade component)
- ✅ ECS task definitions with sensor and vector containers
- ✅ Security group (egress-only, auto-created)
- ✅ IAM roles for ECS task execution

## Requirements

- Terraform >= 1.3
- AWS provider >= 5.0
- ECS cluster (EC2-backed)
- Private subnets with NAT Gateway
- Valid AWS Secrets Manager secrets
| AWS       | >= 5.0  |
