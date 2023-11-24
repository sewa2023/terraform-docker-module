# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {
}

# Create Web Security Group
resource "aws_security_group" "web-sg" {
  name        = var.aws_security_group
  description = "Allow ssh and http inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description = "ingress port "
    #from_port   = ingress.value
    from_port   = var.start_port
    to_port     = var.end_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "ingress port "
    #from_port   = ingress.value
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

  tags = {
    Name = var.aws_security_group
  }
}


# Generates a secure private k ey and encodes it as PEM
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Create the Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "keypair.pem"
  content  = tls_private_key.ec2_key.private_key_pem
}

#data for amazon linux

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

#create ec2 instances 

resource "aws_instance" "DockerInstance" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = var.key_name
  #user_data              = file("install.sh")

  tags = {
    Name = var.aws_instance
  }
  provisioner "local-exec" {
    command = "sleep 300"
  }
}





