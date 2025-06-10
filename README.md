# Deploy a Minecraft Server
*By Matthew Martin*

## Backgound

The purpose of this repository is to create a minecraft server without needing to access the aws dashboard, the aws instance, or needing to use any CLI commands besides the setup. 

To do this, at a high level, I essentially uses shell script(s) to automate the entire process of:
- Using terraform to create the aws instance using the users aws credentials, 
- An ansible playbook will then be ran to access via SSH,
- Then do a series of tasks to download the necessary resources for the minecraft server,
- Followed by creating a systemd service file to keep the minecraft server running.


## Requirements

### User Configuration
No specific configuration is needed to run the pipeline, other than:
1. Pasting their AWS credentials in the cred file *(under `aws_creds/cred`)*
2. Make sure the shell scripts are executable with `chmod +x [file]`

***[OPTIONAL]***
The user can decide to create their own SSH keypair if they desire, though they will need to, as the script will create one:
- Name it `minecraft-key` 
- create it in the ssh_creds directory
- and comment out the creation of the key in the 'main.sh' script *(i.e. `ssh-keygen -t rsa -b 4096 -a 100 -N '' -f minecraft-key`)*.

Other than that, the script should configure all that is necessary.

### Tools 

The main tools used include:
- Terraform *(with AWS CLI)* and Ansible. 
This uses the latest versions of each, and the script includes an install using pacman for them. 
- If you do not have any of these tools, or run into an error installing them via the scripts, I recommend installing them manually to your local device before running the script. 

### Credentials and CLI

There is two main credentials used in the automation process:
1. **AWS**

To actually create the aws instance, its necessary for terraform/awscli to have the user's AWS credentials. Simply paste the credentials in the `cred` file. It should look like the standard `~/.aws/credentials` file:
```
[default]
aws_access_key_id=<key id here>
aws_secret_access_key=<access key here>
aws_session_token=<token here>
```
2. **SSH**

The mains script will create the ssh key called `minecraft-key` during runtime for convenience, however you can also manually create your key as such:
```
cd ../ssh_creds
ssh-keygen -t rsa -b 4096 -a 100 -N '' -f minecraft-key
cd ..
```

The **Commands To Run** section will outline the specific commands to run to execute this script, though to summarize:
- `cd scripts`
- `chmod +x downloadtools.sh`
- `chmod +x main.sh`
- `./main.sh`

This is assuming the user already pasted their AWS credentials in the cred file under `aws-creds/cred` as mentioned above.

No extra configuration is needed beyond whats mentioned above, as the scripts should run the pipeline properly.

## Pipeline

### Pipeline Diagram

![a gorgeous diagram of the process pipeline](pipeline-diagram.png)

### General Pipeline Overview

Shell script is used to mediate the processes and tools necessary to create and service the AWS instance. After the user makes the scripts executable: 

- the `downloadtools.sh` script will download Terraform, AWS CLI, and Ansible,
- Create ssh keys in shh_creds if they don't exist.

Then we move into the terraform directory to `init` and `apply` the defined settings. In general, this will create the aws instance, configure security groups, add the SSH keys, and output the instance's public IP.

Once the instance is set up, the script process will sleep for a moment to make sure the instance is fully set-up before SSH'ing in. After this, the script will add the server's IP, username, and keys to the ansible inventory to access.

Once all this set-up is done, we will run the ansible-playbook, which will:
- Access the instance via SSH,
- Update apt cache,
- Create minecraft directory,
- own the directory,
- download minecraft,
- accept EULA,
- create the minecraft service (using a premade .j2 file found in /ansible/templates),
- and finally start the service.

The final step of the pipeline is to output the public IP once again for the user to connect. 


## Steps to Run
Make sure to paste in your AWS credentials in `aws-creds/cred` as mentioned above before the following steps.

1. Change to `scripts` directory:

```
cd scripts
```

2. Make `main.sh` and `downloadtools.sh` executable:

```
chmod +x main.sh
chmod +x downloadtools.sh
```

3. Paste AWS Credentials into `aws-creds/cred` file. Terraform 

```
[default]
aws_access_key_id=<key id here>
aws_secret_access_key=<access key here>
aws_session_token=<token here>
```

4. Run `main.sh`:

```
./main.sh
```

Now wait and watch as the script creates the instance and runs the server. It should take about one to two minutes.


## Steps to Shutdown

1. Change to `scripts` directory:

```
cd scripts
```
2. Make `shutdown.sh` executable:

```
chmod +x shutdown.sh
```
3. Run `shutdown.sh`:

```
./shutdown.sh
```
Now wait a few moments while the server is being destroyed. It is set to auto-approve input, hence no input is necessary. 

## Connecting to the Server
  
1. In minecraft you will click the `Multiplayer` button from the homescreen, then `Add Server`.

2. Next paste in the server IP that was output when setting up the server in the `Server Address` section.
3. Add the following to the end of the `Server Address`, which represents minecrafts default port:
```
:25565
```
4. Press done and connect!


## Sources Used:
- https://stackoverflow.com/questions/49743220/how-to-create-an-ssh-key-in-terraform
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
- https://developer.hashicorp.com/terraform/language
- https://dev.to/andreagrandi/getting-latest-ubuntu-ami-with-terraform-33gg
- https://cloudkatha.com/how-to-create-security-groups-in-aws-using-terraform/
- https://developer.hashicorp.com/terraform/cli/commands/apply#auto-approve
- https://linuxbuz.com/devops/ansible-playbook-hosts-option
- https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html
- https://stackoverflow.com/questions/22844905/how-to-create-a-directory-using-ansible
- https://www.middlewareinventory.com/blog/ansible-copy-examples/
- https://www.digitalocean.com/community/tutorials/how-to-create-and-use-templates-in-ansible-playbooks
- https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_service_module.html#ansible-collections-ansible-builtin-systemd-service-module
- https://stackoverflow.com/questions/64124063/how-to-make-terraform-to-read-aws-credentials-file
- https://askubuntu.com/questions/694769/how-to-script-ssh-keygen-with-no-password


