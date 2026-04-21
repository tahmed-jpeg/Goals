variable "project_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "private_subnet_id" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t3.medium"
}

variable "ami_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "bastion_sg_id" {
    type = string
}

variable "jenkins_sg_id" {
    type = string
}