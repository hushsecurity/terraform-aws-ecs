# Existing Secret Example – ECS Sensor Deployment

This example deploys the Hush ECS sensor service on EC2-backed ECS using the root Terraform module, referencing **pre-existing Secrets Manager ARNs**.

## What It Does

- Registers a daemon-mode ECS service (1 task per EC2 instance)
- Defines a task with `sensor` and `sensor-vector` containers
- Injects deployment and registry credentials via existing Secrets Manager ARNs
- Creates a minimal ECS execution role with access to logs and secrets

## Usage

Create a `terraform.tfvars` file with the following:

```hcl
cluster_name                              = "your-ecs-cluster-name"
deployment_credentials_secret_arn         = "arn:aws:secretsmanager:...:hush-deployment-credentials-{suffix}"
container_registry_credentials_secret_arn = "arn:aws:secretsmanager:...:hush-container-registry-credentials-{suffix}"
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
