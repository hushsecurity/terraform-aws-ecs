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

deployment_token              = "your-deployment-token"
deployment_password           = "your-deployment-password"

container_registry_username   = "your-registry-username"
container_registry_password   = "your-registry-password"
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
