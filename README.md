# minecraft-server

*The following is just random things that need done to run the code properly so I don't forget later:*

- User needs to have Terraform, AWS CLI and AWS Credentials. 
- Maybe clarify how automated it should be before working on the actual automation (i.e. use ansible to download key resources such as terraform, aws cli, etc.)


So far the process will look like:
- User changes script permissions to executable
- Instruct the user to paste the AWS credentials file in the "cred"
- User needs to keygen within the ssh_creds directory
ssh-keygen -t rsa -b 4096 -a 100 -f minecraft-key
- 
- User calls main script:
  - shell script to check for terraform, aws, and ansible- download if not installed. 
  - Runs terraform (init and apply)
    - *According to https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform I can create the ssh key pair, create the ubuntu instance, then use output to push private key variable (and public IP likely) to a .pem file (piping it with > prolly). Then deploy the ansible playbook onto the instance... 
    - Could do this with a user created key, but might be cooler to with terraform created one. Less safe tho*
  - Sleeps for 25 seconds, necessary for server to be up.
  - Ansible SSH's into the server, user will have to type "yes" for this unfortunately.
  - Ansible goes through playbook tasks
    - Update apt cache (aka apt update)
    - Install java via apt
    - Create the minecraft directory, with correct perms.
    - Change ownership of directory (this killed me during debugging)
    - Download minecraft via wget
    - Accept EULA (aka paste in content to the file)
    - Create the minecraft service by inserting the premade service.j2 file.
    - Start the service.
    - *minecraft server restart after reboot (it takes a bit tho).*


TO-DO:

- Finished terraform, ansible.
- Need to clean up:
  - write docs
  - Create git ignore and add the SSH keys and aws credential files for good practice, despite it not ever being pushed. 



Source List So far:
- CoPilot for questions and general info
- https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
- https://developer.hashicorp.com/terraform/language
- https://dev.to/andreagrandi/getting-latest-ubuntu-ami-with-terraform-33gg
- https://cloudkatha.com/how-to-create-security-groups-in-aws-using-terraform/
- https://developer.hashicorp.com/terraform/cli/commands/apply#auto-approve (found from a stackoverflow post when googling)
- https://linuxbuz.com/devops/ansible-playbook-hosts-option
- https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html
- https://stackoverflow.com/questions/22844905/how-to-create-a-directory-using-ansible
- https://www.middlewareinventory.com/blog/ansible-copy-examples/
- https://www.digitalocean.com/community/tutorials/how-to-create-and-use-templates-in-ansible-playbooks
- https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_service_module.html#ansible-collections-ansible-builtin-systemd-service-module
- https://stackoverflow.com/questions/64124063/how-to-make-terraform-to-read-aws-credentials-file
- https://askubuntu.com/questions/694769/how-to-script-ssh-keygen-with-no-password
- 


# Deploy a Minecraft Server

## Requirements

### Tools 

The main tools used include:
- 

