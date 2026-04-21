resource "aws_security_group" "jenkins_sg" {
    name = "${var.project_name}-jenkins-sg"
    description = "Allow SSH from Bastion and port 8080 within VPC"
    vpc_id = var.vpc_id

    ingress {
        description = "SSH from Bastion only"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [var.bastion_sg_id]
    }

    ingress {
        description = "Jenkins Web UI from within VPC"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-jenkins-sg"
    }
        
    
}

resource "aws_instance" "jenkins" {
    ami = var.ami_id 
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    key_name = var.key_name

    user_data = <<-EOF
        #!/bin/bash
        apt-get update -y
        apt-get install -y fontconfig openjdk-21-jre

        java -version 

        mkdir -p /etc/apt/keyrings

        wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
        echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

        apt-get update -y
        apt-get install -y jenkins
        systemctl enable jenkins
        systemctl start jenkins
    EOF

    root_block_device {
      volume_size = 20
      volume_type = "gp3"
    }

    tags = {
        Name = "${var.project_name}-jenkins"
    }

}