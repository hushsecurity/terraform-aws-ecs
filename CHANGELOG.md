# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.2] - 2026-01-05

### Added

- Added `enable_java_probing` variable to control Java probing in the sensor
- When set to `false`, passes `SNOOPY_DISABLE_JAVA_PROBING=true` to sensor container
- Defaults to `true` (Java probing enabled by default)

## [1.1.1] - 2025-12-22

### Added

- **Vermon Module**:
  - Added `CHANNEL_DIGESTS_ENDPOINT` environment variable to enable digest-based auto-update functionality
  - Endpoint is dynamically constructed from container registry: `https://hush-runtime-config.s3.amazonaws.com/cr-digests/${var.container_registry}/channels.json`

### Changed

- **Examples**:
  - Reorganized examples for Terraform Registry deployment readiness
  - Updated module source to use `hushsecurity/ecs/aws` with version constraints
  - Simplified variables to essential parameters only
  - Improved documentation with clearer quick-start guides
  - Streamlined terraform.tfvars with clean placeholders

### Fixed

- **Outputs**:
  - Added safe output handling with `try()` function for disabled services
  - Prevents crashes when `enable_sensor = false` or `enable_vermon = false`
  - All sensor and vermon outputs now return `null` safely when modules are disabled

### Reverted

- **Vermon Module**:
  - Re-enabled `hush_vermon` module by default (reverted HUSH-2826 disable-by-default change)

## [1.1.0] - 2025-09-16

### Added

- **IAM Role Separation**:
  - Separated ECS execution role from task roles following AWS security best practices
  - Execution role handles container startup and secrets access
  - Task roles provide minimal runtime permissions specific to each service
  - Sensor module now receives task_role_arn for AWS service integration

- **AWSVPC Networking Support**:
  - `network_mode = "awsvpc"` for both sensor and vermon modules
  - Dedicated Elastic Network Interface (ENI) per task
  - Enhanced network isolation with security group controls
  - New variables: `vpc_subnets` and `security_groups` for network configuration

- **Auto-Created Security Groups**:
  - New `vpc_id` variable for automatic egress-only security group creation
  - Allows all outbound traffic for container registry access and deployment reporting
  - Dual security group management options: existing groups or auto-creation
  - Enhanced validation logic ensuring either `security_groups` or `vpc_id` is provided

### Changed

- **Network Architecture**:
  - Migrated from bridge networking to AWSVPC mode
  - Updated ECS services with `network_configuration` blocks

### Enhanced

- **Documentation**:
  - Added comprehensive AWSVPC networking guide
  - Updated README with network requirements and configuration

- **Vermon Module**:
  - `hush_vermon` module for ECS auto-upgrade functionality
  - `enable_vermon` toggle (disabled by default)
  - `vermon_tag` variable for container image version
  - Integration with container registry authentication
  - Test mode environment variables support

### Changed

- **IAM Permissions**:
  - Added ECS task management permissions for Vermon (`ecs:DescribeTaskDefinition`, `ecs:ListTasks`, `ecs:DescribeTasks`)

## [1.0.0] - 2025-08-04

### Added

- Initial support for deploying the Hush sensor as a Daemon ECS service on EC2.
- `hush_sensor` module:
  - ECS task definition and privileged daemon-mode service.
  - HostPath volumes for container runtimes (`docker.sock`, `containerd.sock`, `cgroup`).
  - Optional container registry auth via `repositoryCredentials`.
- `secrets` module:
  - Manages ECS secret injection for deployment token, password, and container registry credentials.
  - Supports pre-existing secret ARNs or creates new ones via `tfvars`.
- `iam` module:
  - Defines the ECS execution role (`hush-ecs-role`) with inline policy.
- Root module:
  - Wires together IAM, Secrets Manager, and ECS service into a reusable module.
  - Injects all shared inputs and exposes outputs cleanly.
- Configuration toggles:
  - `enable_sensor`, `event_reporting_console`, `trace_host`, `trace_pods_default`, `report_tls`, `akeyless_gateway_domain`.
- Input validation:
  - Ensures `cluster_name` is not empty.
- Public module examples that reference the Terraform Registry
- Updated documentation for public repository usage

### Changed
- Examples now use public module source from Terraform Registry
- Updated all documentation to reflect public repository status

## [0.0.1] - 2025-07-08

### Added

- First public release of the `terraform-hush-ecs` module.
- Includes all modules, wiring, secrets, IAM roles, and ECS service definition.

[unreleased]: https://github.com/hushsecurity/terraform-hush-ecs/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/hushsecurity/terraform-hush-ecs/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/hushsecurity/terraform-hush-ecs/compare/v0.0.1...v1.0.0
[0.0.1]: https://github.com/hushsecurity/terraform-hush-ecs/releases/tag/v0.0.1
