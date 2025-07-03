clean:
	@echo "Cleaning up Terraform and TFLint cache files..."
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name "*.tfplan" -exec rm -f {} +
	find . -type f -name "*.tfstate*" -exec rm -f {} +
	rm -rf .tflintcache/
