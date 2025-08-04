# Terraform Module Makefile
MODULE_NAME = terraform-hush-ecs

.PHONY: all
all: check

.PHONY: clean
clean:
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.tfplan" -exec rm -f {} + 2>/dev/null || true
	@find . -type f -name "*.tfstate*" -exec rm -f {} + 2>/dev/null || true
	@rm -rf .tflintcache/

.PHONY: format
format:
	@terraform fmt -recursive .

.PHONY: format-check
format-check:
	@terraform fmt -check=true -diff=true -recursive .

.PHONY: lint
lint:
	@tflint --init
	@tflint
	@for dir in examples/*/; do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "  → Linting $$dir"; \
			(cd "$$dir" && tflint --init && tflint); \
		fi; \
	done

.PHONY: validate
validate:
	@terraform init -backend=false
	@terraform validate
	@for dir in examples/*/; do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "  → Validating $$dir"; \
			(cd "$$dir" && terraform init -backend=false && terraform validate); \
		fi; \
	done

.PHONY: check
check: format-check validate lint
	@echo "✅ All checks passed!"
