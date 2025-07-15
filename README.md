# Terraform AWS ECS Deployment (Hush Security)

Reusable Terraform module for deploying **Hush Security components** on AWS ECS using the `DAEMON` scheduling strategy (EC2 launch type).

---

## 📁 Project Structure

```
.
├── examples
│   └── base                         # Configuration to deploy the Hush ECS services on EC2-backed ECS
├── iam.tf                           # IAM role and policies for ECS execution
├── main.tf                          # Root module wiring IAM, secrets, ECS task
├── modules
│   └── hush_sensor                  # Configuration for hush_sensor service module
├── outputs.tf                       # Root outputs
├── variables.tf                     # Root input variables
├── secrets.tf                       # Secrets Manager integration
├── terraform.tf                     # Terraform block (providers, versions)
└── README.md
```

---

## ✅ Prerequisites

- Terraform `>= 1.3`
- AWS CLI with valid credentials
- Existing ECS cluster (EC2 launch type)
- Existing EC2 instances registered to the cluster
- IAM permissions for ECS, IAM, and Secrets Manager

---

## ▶️ Usage

1. Navigate to the example directory:

   ```bash
   cd examples/base
   ```

2. Define your credentials and configuration in `terraform.tfvars`, for example:

   ```hcl
   aws_region  = "eu-west-1"
   cluster_name = "my-ecs-cluster"

   container_registry_username  = "my-container-registry-username"
   container_registry_password  = "my-container-registry-password"

   deployment_token    = "my-deployment-token"
   deployment_password = "my-deployment-password"
   ```

3. Initialize and apply:

   ```bash
   terraform init
   terraform apply
   ```

---

## 🔐 Secrets Management

This module supports **two modes** for injecting secrets into ECS tasks:

### 1. **Create and store via Terraform**
Set these values in `terraform.tfvars`:

- `deployment_token`
- `deployment_password`
- `container_registry_username`
- `container_registry_password`

Terraform will upload these to Secrets Manager and pass them securely to the ECS task.

### 2. **Use existing Secrets Manager ARNs**
Instead of secret values, use:

- `deployment_credentials_secret_arn`
- `container_registry_credentials_secret_arn`

---

## ⚙️ Features

- ECS DAEMON-style deployment (1 task per EC2 instance)
- Deploys both `sensor` and `sensor-vector` containers
- Supports private container registries (e.g. Azure Container Registry)
- Secure secrets injection via AWS Secrets Manager
- Configurable CPU/memory requests and limits

---

## 📤 Outputs

See [`outputs.tf`](./outputs.tf) for details. Notable outputs include:

- ECS service name
- Task definition ARN
- Resolved secret ARNs

---

## 🧪 Example

For a working example, see [`examples/base`](./examples/base).

---

## 📝 License

© 2025 Hush Security. All rights reserved.
