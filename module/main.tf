module "Dockerlab" {
  source             = "../docker-Lab"
  aws_instance       = "Docker"
  region             = "us-east-1"
  instance_type      = "t2.micro"
  key_name           = "privatekeypair"
  aws_security_group = "docker-sg1"
  start_port         = "8000"
  end_port           = "8110"
    
}

output "public-ip" {
  value = module.Dockerlab.public-ip
}