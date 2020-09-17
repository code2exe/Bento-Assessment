# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#     }
#   }
#   backend "s3" {
#     bucket = "bento-backend"
#     key    = "terraform.tfstate"
#     region = "eu-west-2"
#     encrypt = true
#     }

# }


provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "Bento_VPC"
  }
}

resource "aws_internet_gateway" "gateway" {
     vpc_id = aws_vpc.vpc.id
     tags = {
      Name = "Bento_IG"
  }
 }
 
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.vpc_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.gateway]
  tags = {
    Name = "Bento_VPC_Subnet"
  }
}
 
resource "aws_route_table" "route" {
 vpc_id = aws_vpc.vpc.id
 
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
 }
 tags = {
    Name = "BentoRT"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.route.id
}

resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "-1"
    rule_no    = 150
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "-1"
    rule_no    = 150
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "BentoACL"
  }
}
resource "aws_security_group" "default" {
     name        = "http-https-allow"
     description = "Allow incoming HTTP and HTTPS and Connections"
     vpc_id      = aws_vpc.vpc.id
     ingress {
         from_port = 80
         to_port = 80
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
         from_port = 443
         to_port = 443
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
     tags = {
    Name = "BentoSG"
  }
}

# EC2 IAM Role
resource "aws_iam_role" "iam_ec2_role" {
  name = "iam_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "iam_ec2_profile" {
  name = "iam_ec2_profile"
  role = aws_iam_role.iam_ec2_role.name
}

resource "aws_iam_role_policy" "iam_ec2_policy" {
  name = "iam_ec2_policy"
  role = aws_iam_role.iam_ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# AWS Instance

resource "aws_instance" "instance" {
  ami = var.ec2_ami
  availability_zone = data.aws_availability_zones.available.names[0]
  instance_type = "t2.micro"
  monitoring = true
  iam_instance_profile = aws_iam_instance_profile.iam_ec2_profile.name
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id = aws_subnet.subnet.id
  key_name = var.ec2_key_name
  tags = {
    name = "BentoInstance"
  }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.instance.id
  depends_on = [aws_internet_gateway.gateway]
  tags = {
    name = "BentoIP"
  }
}
