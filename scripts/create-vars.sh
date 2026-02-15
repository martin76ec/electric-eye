#!/usr/bin/env bash

set -e
set -u

# This script reads configuration from config.lua and exports it
# for use by other scripts and terraform.

# Check if lua is installed
if ! command -v lua &> /dev/null
then
    echo "Error: lua could not be found. Please install lua to continue."
    exit 1
fi

echo "Reading configuration from config.lua..."

# Read values from config.lua
PROJECT=$(lua -e 'print(require("config").PROJECT)')
ENV=$(lua -e 'print(require("config").ENV)')
AWS_REGION=$(lua -e 'print(require("config").AWS_REGION)')

# Export as environment variables
export PROJECT
export ENV
export AWS_REGION

echo "Exported environment variables: PROJECT, ENV, AWS_REGION"

# Create terraform.tfvars
cat <<EOF > infra/terraform.tfvars
project = "$PROJECT"
env = "$ENV"
aws_region = "$AWS_REGION"
EOF

echo "Created infra/terraform.tfvars"
