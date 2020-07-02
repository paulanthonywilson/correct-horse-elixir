variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

variable "domain_name" {
  description = "the domain name, to look up the aws cert or whatevs"
}

variable "release_name" {
  description = "app to be released"
}

variable "instance_count" {
  description = "number of instances to deploy"
  default = 1
}

# Ubuntu  focal 20.04 LTS
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-0ed613086d754c853"
    eu-west-2 = "ami-082bcf37bf94b4417"
  }
}
