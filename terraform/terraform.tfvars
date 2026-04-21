aws_region = "us-east-1"
project_name = "goals-app"
key_name = "goals-key"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24"
]

private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24",
    "10.0.15.0/24"
]

availability_zones = [ 
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
    "us-east-1f"
]

ami_id = "ami-00de3875b03809ec5"