terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "bastion" {
  source           = "./modules/bastion"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  instance_type    = "t3.micro"
  ami_id           = var.ami_id
  key_name         = var.key_name
}

module "jenkins" {
  source            = "./modules/jenkins"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_ids[0]
  instance_type     = "t3.medium"
  ami_id            = var.ami_id
  key_name          = var.key_name
  bastion_sg_id     = module.bastion.bastion_sg_id
}

module "sonarqube" {
  source            = "./modules/sonarqube"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_ids[1]
  instance_type     = "t3.medium"
  ami_id            = var.ami_id
  key_name          = var.key_name
  bastion_sg_id     = module.bastion.bastion_sg_id
  jenkins_sg_id     = module.jenkins.jenkins_sg_id
}