#!/bin/bash
# Change name if this ends up being a subprocess for a main shell script
echo "Checking for necessary applications..."
# Check for Terraform
if ! command -v terraform &> /dev/null; then
    echo "Terraform not found. Installing..."
    pacman -S terraform
fi

# Check for AWS CLI
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Installing..."
    yay -S aws-cli-v2
fi

# Check for Ansible
if ! command -v ansible &> /dev/null; then
    echo "Ansible not found. Installing..."
    pacman -S ansible
fi
echo "Done checking/downloading."

