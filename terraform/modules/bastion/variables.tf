variable "project_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "public_subnet_id" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "ami_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "allowed_ssh_cidr" {
    description = "Your public IP in CIDR format"
    type = list(string)
    default = ["0.0.0.0/0"]
}