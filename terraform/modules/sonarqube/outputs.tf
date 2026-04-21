output "sonarqube_private_ip" {
    value = aws_instance.sonarqube.private_ip
}

output "sonarqube_sg_id" {
    value = aws_security_group.sonarqube_sg.id
}