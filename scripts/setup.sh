#!/bin/bash

echo "Creating docker image..."

echo $(
  ./scripts/build.sh ./infra ./lambda/agent-evaluator aiops-agent-evaluator)

echo "Creating terraform resources"
cd ./infra \
      && terraform init \
      && terraform apply

echo "Setup finished."
