terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region = var.aws_region
  shared_credentials_files = ["../aws-creds/cred"]
  profile= "default"
}

# defines the key pair for the instance
# defined in the variables.tf file (var)
resource "aws_key_pair" "minecraft_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# creates security group (SSH)
resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# creates security group (minecraft)
resource "aws_security_group" "minecraft_access" {
  name        = "minecraft-access"
  description = "Allow Minecraft server access"

  ingress {
    from_port = 25565
    to_port   = 25565
    protocol    = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# fetches the ubuntu ami for the instance
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (aka trusted source)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# creates the instance resource
resource "aws_instance" "minecraft_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh_access.id,
    aws_security_group.minecraft_access.id
  ]

  tags = {
    Name = "MinecraftServer"
  }
}

output "public_ip" {
  value = aws_instance.minecraft_server.public_ip
}
