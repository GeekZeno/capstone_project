variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "clouddeploy"
}

# public key to create EC2 key pair (path to your public key on jump box)
variable "public_ssh_key_path" {
  description = "Path to public ssh key file (id_rsa.pub) used for EC2 key pair"
  type        = string
  default     = "/var/lib/jenkins/.ssh/terraform_key.pub"
}

