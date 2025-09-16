# Terraform AWS ECS Deployment (Hush Security)

Reusable Terraform module for deploying **Hush Security components** on AWS ECS using the `DAEMON` scheduling strategy (EC2 launch type).

---

## 📁 Project Structure

```
.
├── examples
│   ├── existing_secret              # Example using pre-existing secrets  
│   └── generated_secrets            # Example creating new secrets
├── iam.tf                           # IAM role and policies for ECS execution
├── main.tf                          # Root module wiring IAM, secrets, ECS task
├── modules
│   ├── hush_sensor                  # Configuration for hush_sensor service module
│   └── hush_vermon                  # Configuration for hush_vermon auto-upgrade module
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

1. Navigate to an example directory:

   ```bash
   cd examples/generated_secrets
   # OR
   cd examples/existing_secret
   ```

2. Define your credentials and configuration in `terraform.tfvars`, for example:

   ```hcl
   cluster_name = "my-ecs-cluster"

   # Container registry credentials  
   container_registry_username = "my-container-registry-username"
   container_registry_password = "my-container-registry-password"

   # Deployment credentials
   deployment_token    = "my-deployment-token"
   deployment_password = "my-deployment-password"

   # AWSVPC networking (required)
   vpc_subnets = [
     "subnet-xxxxxx",  # Private subnet A
     "subnet-yyyyyy",  # Private subnet B  
     "subnet-zzzzzz"   # Private subnet C
   ]
   security_groups = ["sg-xxxxxxxxx"]
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
- **Auto-upgrade capability via Vermon** (optional, enabled by default)
- **AWSVPC networking support** with dedicated ENI per task
- Supports private container registries (e.g. Azure Container Registry)
- Secure secrets injection via AWS Secrets Manager
- Configurable CPU/memory requests and limits

---

## 🌐 AWSVPC Networking

This module supports **AWSVPC networking mode** for enhanced network isolation and security.

### Key Features
- **Dedicated ENI per task** with individual IP addresses
- **Security group isolation** for fine-grained network controls  
- **VPC subnet placement** across multiple availability zones
- **Task role support** for AWS service integration

### Required Variables for AWSVPC
```hcl
vpc_subnets = [
  "subnet-xxxxxx",  # Private subnet A
  "subnet-yyyyyy",  # Private subnet B  
  "subnet-zzzzzz"   # Private subnet C
]

security_groups = ["sg-xxxxxxxxx"]  # Dedicated security group
```

### Network Requirements
- **Private subnets** with NAT Gateway for internet access
- **Security group rules** allowing:
  - Outbound HTTPS (443) for container registry access
  - Any application-specific ports
- **Task role** with ENI management permissions (automatically configured)

---

## 🔄 Auto-Upgrade (Vermon)

The module includes optional **Vermon** component for automated container updates:

### Enable Vermon
```hcl
enable_vermon           = true
vermon_update_frequency = "8h"  # Check frequency
```

### How It Works
- Monitors ECS services for new container image versions
- Automatically triggers service updates when new images are available
- Uses channel digests to determine update availability
- Provides centralized upgrade management across multiple services

---

## 📤 Outputs

See [`outputs.tf`](./outputs.tf) for details. Notable outputs include:

- ECS service name
- Task definition ARN
- Resolved secret ARNs

---

## 🧪 Example

For working examples, see [`examples/generated_secrets`](./examples/generated_secrets) and [`examples/existing_secret`](./examples/existing_secret).

---

## 📝 License

© 2025 Hush Security. All rights reserved.
