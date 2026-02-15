allow:
	sudo chmod u+x scripts/*.sh && ls -la ./scripts

setup:
	sh scripts/setup.sh

lint:
	tflint --recursive --config "$(CURDIR)/.tflint.hcl"

format:
	terraform fmt --recursive
