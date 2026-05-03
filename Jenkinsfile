pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
        FRONTEND_IMAGE = "tahmed2026/goals-frontend"
        BACKEND_IMAGE = "tahmed2026/goals-backend"
        IMAGE_TAG = "${BUILD_NUMBER}"
        CONFIG_REPO = "https://github.com/tahmed-jpeg/goals-config-repo.git"
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

        stage('Update Manifest') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh """
                        rm -rf goals-config-repo
                        git clone https://${GIT_USER}:${GIT_TOKEN}@github.com/tahmed-jpeg/goals-config-repo.git
                        cd goals-config-repo
                        sed -i 's|${FRONTEND_IMAGE}:.*|${FRONTEND_IMAGE}:${IMAGE_TAG}|g' manifest/frontend-deployment.yaml
                        sed -i 's|${BACKEND_IMAGE}:.*|${BACKEND_IMAGE}:${IMAGE_TAG}|g' manifest/backend-deployment.yaml
                        git config user.email "jenkins@goals-app.com"
                        git config user.name "Jenkins"
                        git add manifest/frontend-deployment.yaml manifest/backend-deployment.yaml
                        git commit -m "update image tags to ${IMAGE_TAG}"
                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/tahmed-jpeg/goals-config-repo.git main
                    """
                }
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
                webhookURL: "https://discord.com/api/webhooks/1500554283064758445/h0FS-jaXZgCP9OIevBYjJXOH02HP_yOFOcT6NcJ8xqvxeCg0vWzLV53pesjBLS4rzHeZ"
        }
        failure {
            discordSend description: "Pipeline FAILED - Build #${BUILD_NUMBER}",
                footer: "Goals App CI/CD Pipeline",
                link: env.BUILD_URL,
                result: currentBuild.currentResult,
                title: "goals-pipeline",
                webhookURL: "https://discord.com/api/webhooks/1500554283064758445/h0FS-jaXZgCP9OIevBYjJXOH02HP_yOFOcT6NcJ8xqvxeCg0vWzLV53pesjBLS4rzHeZ"
        }
    }
}
