#!/bin/bash

set -e
set -o pipefail

TERRAFORM_DIR="$1"

DOCKER_DIR="$2"

IMAGE_TAG="${3:-latest}"

TF_MODULE_TARGET="module.ecr_lambda_images"

TF_OUTPUT_NAME="ecr_repo_url"


if [ -z "$TERRAFORM_DIR" ] || [ -z "$DOCKER_DIR" ]; then
  echo "Error: Missing required arguments."
  echo "Usage: $0 <path-to-terraform-dir> <path-to-docker-dir> [image-tag]"
  exit 1
fi

if [ ! -d "$TERRAFORM_DIR" ]; then
  echo "Error: Terraform directory '$TERRAFORM_DIR' does not exist."
  exit 1
fi

if [ ! -d "$DOCKER_DIR" ]; then
  echo "Error: Docker directory '$DOCKER_DIR' does not exist."
  exit 1
fi

ABS_DOCKER_DIR=$(readlink -f "$DOCKER_DIR")
ABS_TERRAFORM_DIR=$(readlink -f "$TERRAFORM_DIR")

echo "--- Using Terraform directory: $ABS_TERRAFORM_DIR"
echo "--- Using Docker build context: $ABS_DOCKER_DIR"

ORIGINAL_PWD=$(pwd)

export AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

if [ -z "$AWS_ACCOUNT_ID" ]; then
    echo "Error: Could not get AWS Account ID. Check AWS credentials."
    exit 1
fi

echo "--- Using AWS Region: $AWS_REGION ---"
echo "--- Using AWS Account ID: $AWS_ACCOUNT_ID ---"


echo "--- Changing to Terraform directory ---"
cd "$ABS_TERRAFORM_DIR"

# Build ECR Module
echo "--- Initializing and applying Terraform module: $TF_MODULE_TARGET ---"
terraform init
terraform apply -target="$TF_MODULE_TARGET" -auto-approve

echo "--- Fetching ECR repository URL from output: $TF_OUTPUT_NAME ---"
ECR_REPO_URL=$(terraform output -raw "$TF_OUTPUT_NAME")

if [ -z "$ECR_REPO_URL" ]; then
  echo "Error: Could not get ECR repo URL from Terraform output '$TF_OUTPUT_NAME'."
  echo "Please ensure the output exists in your root configuration."
  cd "$ORIGINAL_PWD"
  exit 1
fi

echo "Repository URL: $ECR_REPO_URL"

# Login to ECR 
echo "--- Authenticating Docker with ECR ---"
aws ecr get-login-password --region "$AWS_REGION" | docker login \
  --username AWS \
  --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Docker login successful."

# Build Docker Image
FULL_IMAGE_NAME="$ECR_REPO_URL:$IMAGE_TAG"
echo "--- Building Docker image: $FULL_IMAGE_NAME ---"
docker build --platform linux/amd64 --provenance=false -t "$FULL_IMAGE_NAME" "$ABS_DOCKER_DIR"
echo "Docker build complete."

echo "--- Pushing image to ECR ---"
docker push "$FULL_IMAGE_NAME"

echo "--- Returning to original directory: $ORIGINAL_PWD ---"
cd "$ORIGINAL_PWD"

echo "--- ✅ Success! Image pushed to $FULL_IMAGE_NAME ---"
