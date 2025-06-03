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

You don't need to go step by step over the different commands as these will live in your scripts.

The README file/tutorial needs to contain the following:

    Background: What will we do? How will we do it? 
    Requirements:
        What will the user need to configure to run the pipeline?
        What tools should be installed?
        Are there any credentials or CLI required?
        Should the user set environment variables or configure anything?
    Diagram of the major steps in the pipeline. 
    List of commands to run, with explanations.
    How to connect to the Minecraft server once it's running?



# Deploy a Minecraft Server

## Backgound

The purpose of this repository is to create a minecraft server without needing to access the aws dashboard, the aws instance, or needing to use any CLI commands besides the setup. 

To do this, at a high level, I essentially uses shell script(s) to automate the entire process of:
- Using terraform to create the aws instance using the users aws credentials, 
- An ansible playbook will then be ran to access via SSH,
- Then do a series of tasks to download the necessary resources for the minecraft server,
- Followed by creating a systemd service file to keep the minecraft server running.


## Requirements

# User Configuration
No specific configuration is needed to run the pipeline, other than:
1. Pasting their AWS credentials in the cred file *(under `aws_creds/cred`)*
2. Make sure the shell scripts are executable with `chmod +x [file]`

Besides that, the user can decide to create their own SSH keypair if they desire, though they will need to:
- Name it `minecraft-key` 
- create it in the ssh_creds directory
- and comment out the creation of the key in the 'main.sh' script *(i.e. `ssh-keygen -t rsa -b 4096 -a 100 -N '' -f minecraft-key`)*.

Other than that, the script should configure all that is necessary.

### Tools 

The main tools used include:
- Terraform, AWS CLI, and Ansible. 

