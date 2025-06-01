# minecraft-server

*The following is just random things that need done to run the code properly so I don't forget later:*

- User needs to have Terraform, AWS CLI and AWS Credentials. 
- Maybe clarify how automated it should be before working on the actual automation (i.e. use ansible to download key resources such as terraform, aws cli, etc.)


So far the process will look like:
- User changes script permissions to executable
- Instruct the user to input the AWS credentials in the env.example file (and remove the .example)
- 
- User calls main script:
  - shell script to check for terraform, aws, and ansible- download if not installed. 
  - Runs terraform (init and apply)
    - According to https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform I can create the ssh key pair, create the ubuntu instance, then use output to push private key variable (and public IP likely) to a .pem file (piping it with > prolly). Then deploy the ansible playbook onto the instance... 
    - Could do this with a user created key, but might be cooler to with terraform created one. Less safe tho
  - ansible next?


TO-DO:

- terraform files (create instance with correct networking, ssh pair creating)
- Modify shell scripts to push init and apply terraform. Shell script addition for the ssh and ip info for ansible.
- Create Ansible playbook (docker image, minecraft, etc)
- Configure to restart when instance reboots and proper shut-down (unknown rn)
- Documentation and further automation.



Source List So far:
- CoPilot for questions and general info
- https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
- 

