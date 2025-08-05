# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[unreleased]: https://github.com/hushsecurity/terraform-hush-ecs/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/hushsecurity/terraform-hush-ecs/compare/v0.0.1...v1.0.0
[0.0.1]: https://github.com/hushsecurity/terraform-hush-ecs/releases/tag/v0.0.1
