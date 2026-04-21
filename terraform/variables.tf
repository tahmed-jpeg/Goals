variable "aws_region" {
    description = "Which region for AWS"
    type = string
    default = "us-east-1"
}

variable "project_name" {
    description = "Name of the project"
    type = string
    default = "goals-app"
} 

variable "vpc_cidr" {
    description = "CIDR Block"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for the 2 private subnets"
    type = list(string)
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24",
        "10.0.5.0/24",
        "10.0.6.0/24"
    ]
}

variable "private_subnet_cidrs" {
    description = "CIDR blocks for the 2 private subnets"
    type = list(string)
    default = [
        "10.0.11.0/24",
        "10.0.12.0/24",
        "10.0.13.0/24",
        "10.0.14.0/24",
        "10.0.15.0/24",
        "10.0.16.0/24"
    ]
}


variable "availability_zones" {
    description = "Availability zones for subnets"
    type = list(string)
    default = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
        "us-east-1d",
        "us-east-1e",
        "us-east-1f",
        ]
}

variable "ami_id" {
    description = "AMI IDs for EC2 instances"
    type = string
    default = "ami-00de3875b03809ec5"
}

variable "key_name" {
    description = "Name of the EC2 Key Pair"
    type = string
}