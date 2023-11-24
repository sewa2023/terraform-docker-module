variable "aws_instance" {
    default = "Docker" 
}
variable "instance_type" {
    default = "t3.small" 
}
variable "region" {
    default = "us-east-2" 
}
variable "key_name" {
    default = "Privatekeypair1"
}
variable "aws_security_group" {
    default = "docker-sg" 
}
variable "start_port" {
    default = 8000 
}
variable "end_port" {
    default = 8200
}