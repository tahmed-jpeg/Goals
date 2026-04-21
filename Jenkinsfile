pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
        FRONTEND_IMAGE = "tahmed2026/goals-frontend"
        BACKEND_IMAGE = "tahmed2026/goals-backend"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Source Code') {
            steps {
                git branch: 'phase-7',
                    credentialsId: 'github-credentials',
                    url: 'https://github.com/tahmed-jpeg/Goals.git'
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh "docker build -t ${FRONTEND_IMAGE}:${IMAGE_TAG} ./frontend"
            }
        }

        stage('Build Backend Image') {
            steps {
                sh "docker build -t ${BACKEND_IMAGE}:${IMAGE_TAG} ./backend"
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh """
                    trivy image --exit-code 1 --severity CRITICAL ${FRONTEND_IMAGE}:${IMAGE_TAG} || true
                    trivy image --exit-code 1 --severity CRITICAL ${BACKEND_IMAGE}:${IMAGE_TAG} || true
                """
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=goals-app \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://10.0.12.212:9000 \
                        -Dsonar.token=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                sh """
                    echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin
                    docker push ${FRONTEND_IMAGE}:${IMAGE_TAG}
                    docker push ${BACKEND_IMAGE}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        success {
            discordSend description: "Pipeline SUCCESS - Build #${BUILD_NUMBER}",
                footer: "Goals App CI/CD Pipeline",
                link: env.BUILD_URL,
                result: currentBuild.currentResult,
                title: "goals-pipeline",
                webhookURL: "https://discord.com/api/webhooks/1495957760465043486/8mr4wgYhauRiY5vuh6jg7h4UCJwpQ_eYHNPSk5CE9C7npt00dvHV6GvClhNMzJdt9Md0"
        }

        failure {
            discordSend description: "Pipeline FAILED - Build #${BUILD_NUMBER}",
                footer: "Goals App CI/CD Pipeline",
                link: env.BUILD_URL,
                result: currentBuild.currentResult,
                title: "goals-pipeline",
                webhookURL: "https://discord.com/api/webhooks/1495957760465043486/8mr4wgYhauRiY5vuh6jg7h4UCJwpQ_eYHNPSk5CE9C7npt00dvHV6GvClhNMzJdt9Md0"
        }
    }

}