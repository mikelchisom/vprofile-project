pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mikelchisom755/jenkins2:${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS = "mikeldockerid"  // Replace with your Jenkins Docker Hub creds ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mikelchisom/vprofile-project.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package'
                sh 'mvn test'
            }
        }

        stage('Generate Reports') {
            steps {
                sh 'mvn checkstyle:checkstyle'
                sh 'mvn jacoco:report'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh """
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f vpro-container || true
                    docker run -d -p 9000:8080 --name vpro-container ${DOCKER_IMAGE}
                '''
                echo "🚀 Deployed at: http://<your-server-ip>:9000"
            }
        }
    }

    post {
        failure {
            echo '❌ Build failed!'
        }
        success {
            echo '✅ Build and deploy successful!'
        }
    }
}
