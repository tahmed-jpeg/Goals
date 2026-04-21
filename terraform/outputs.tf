output "vpc_id" {
    description = "ID of the created VPC"
    value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
    description = "IDs of the public subnets"
    value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
    description = "IDs of the private subnets"
    value       = module.vpc.private_subnet_ids
}

output "bastion_public_ip" {
    description = "Public IP of the Bastion Host"
    value       = module.bastion.bastion_public_ip
}

output "jenkins_private_ip" {
    description = "Private IP of the Jenkins instance"
    value       = module.jenkins.jenkins_private_ip
}

output "sonarqube_private_ip" {
    description = "Private IP of the SonarQube instance"
    value       = module.sonarqube.sonarqube_private_ip
}