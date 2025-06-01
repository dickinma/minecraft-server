variable "aws_region" {
  default = "us-west-2"
}

variable "key_name" {
  default = "minecraft-key"
}

variable "public_key_path" {
  default = "../ssh_creds/minecraft-key.pub"
}
