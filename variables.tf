variable "aws_access_key" {
  type = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}
variable "aws_region" {
  type = string
  description = "AWS region"
}
variable "vpc_cidr_block" {
  description = "IP addressing for Network"
}
variable "vpc_subnet_cidr" {
  description = "CIDR for externally accessible subnet"
}
variable "ec2_ami" {
  description = "AMI id for EC2"
}
variable "ec2_key_name" {
  description = "SSH Key Name for EC2"
}