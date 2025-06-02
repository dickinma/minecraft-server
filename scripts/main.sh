#!/bin/bash

# runs the download script
source ./downloadtools.sh

# Load AWS credentials from .env if it exists

# ENV_PATH="../aws_creds/cred.env"

# # the [ -f $ENV_PATH ] will essentially check if its a valid path
# if [ -f "$ENV_PATH" ]; then
#   echo "Loading AWS credentials from .env..."
#   source "$ENV_PATH"
# else
#   echo "Env file not found. Create one with your AWS credentials, or else."
#   exit 1
# fi

# Terraform setup
cd ..
cd terraform
terraform init
terraform apply -auto-approve
# add error-handing for resource creation

#grab ip to use with ansible
PUBLIC_IP=$(terraform output public_ip)
echo "$PUBLIC_IP"
echo "sleeping so we can SSH in after server sets up..."
sleep 25
#ansible stuff, probably
chmod 600 ../ssh_creds/minecraft-key
echo "$PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=../ssh_creds/minecraft-key" > ../ansible/inventory

ansible-playbook -i ../ansible/inventory ../ansible/playbook.yml

