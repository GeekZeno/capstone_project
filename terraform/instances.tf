###############################
# EC2 Instances Configuration #
###############################

# Variable for your local SSH public key
# variable "public_ssh_key_path" {
#  description = "Path to the local SSH public key file"
#  type        = string
  # Update this path to your actual public key location on Windows
#  default     = "C:/Users/shaik/.ssh/id_rsa.pub"
# }

# Create an AWS key pair from your local public key
data "local_file" "public_key" {
  filename = var.public_ssh_key_path
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = data.local_file.public_key.content
}

# Latest Ubuntu 22.04 AMI from Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# App instance (Public Subnet A)
resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.medium"
  subnet_id              = aws_subnet.public_a.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-app"
  }
}

# Tools instance (Public Subnet B)
resource "aws_instance" "tools" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.medium"
  subnet_id              = aws_subnet.public_b.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-tools"
  }
}
