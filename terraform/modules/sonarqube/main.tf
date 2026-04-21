resource "aws_security_group" "sonarqube_sg" {
    name = "${var.project_name}=sonarqube-sg"
    description = "Permits SSH from Bastion and port 9000 from Jenkins"
    vpc_id = var.vpc_id

    ingress {
        description = "SSH from Bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [var.bastion_sg_id]
    }

    ingress {
        description = "SonarQube UI from Jenkins"
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        security_groups = [var.jenkins_sg_id]
    }

    ingress {
        description = "SonarQube from within the VPC"
        from_port = 9000
        to_port = 9000
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
        Name = "${var.project_name}-sonarqube-sg"
    }
}

resource "aws_instance" "sonarqube" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
    key_name = var.key_name

    user_data = <<-EOF
        #!/bin/bash
        apt-get update -y
        apt-get install -y openjdk-17-jdk docker.io
        systemctl enable docker
        systemctl start docker

        echo "vm.max_map_count=524288" >> /etc/sysctl.conf
        echo "fs.file-max=131072" >> /etc/sysctl.conf
        sysctl -p

        docker run -d \
            --name sonarqube \
            -- restart always \
            -p 9000:9000
            -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
            sonarqube:lts-community
        EOF

        root_block_device {
            volume_size = 20
            volume_type = "gp3"
        }

        tags = {
            Name = "${var.project_name}-sonarqube"
        }
}