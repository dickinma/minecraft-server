#!/bin/bash

# runs the download script
source ./downloadtools.sh

# Load AWS credentials from .env if it exists


ENV_PATH="../aws_creds/cred.env"

# the [ -f .env ] will essentiall 
if [ -f "$ENV_PATH" ]; then
  echo "Loading AWS credentials from .env..."
  source "$ENV_PATH"
else
  echo "Env file not found. Create one with your AWS credentials, or else."
  exit 1
fi

# Terraform stuff, create the main.tf first
# terraform init
# terraform apply -auto-approve

#ansible stuff, probably
