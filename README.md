# minecraft-server

*The following is just random things that need done to run the code properly so I don't forget later:*

- User needs to have Terraform, AWS CLI and AWS Credentials. 
- Maybe clarify how automated it should be before working on the actual automation (i.e. use ansible to download key resources such as terraform, aws cli, etc.)


So far the process will look like:
-User changes script permissions to executable
- Instruct the user to input the AWS credentials in the env.example file (and remove the .example)
- 
- User calls main script:
  - shell script to check for terraform, aws, and ansible- download if not installed. 
  - Runs terraform (init and apply)
  - ansible next?

