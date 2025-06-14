#!/bin/bash

# runs the download script
#download tools if necessary
source ./downloadtools.sh

# create the ssh keypair

SSH_FILE="../ssh_creds/minecraft-key"
if [ -e "$SSH_FILE" ]; then
    echo "SSH file exists. Continuing without creation"
else
    echo "File does not exist. Creating key"
    cd ..
    cd ssh_creds
    ssh-keygen -t rsa -b 4096 -a 100 -N '' -f minecraft-key
fi


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

# hostkey checking env variable will bypass the yes/no/fingerpeint prompt
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory ../ansible/startPlaybook.yml

echo "Connect using this ip: $PUBLIC_IP"