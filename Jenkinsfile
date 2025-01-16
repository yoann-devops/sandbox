pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'httpd:latest'
        CONTAINER_NAME = 'apache-site'
    }

    stages {
        stage('Check Docker') {
            steps {
                sh 'docker ps'
            }
        )
            
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '/usr/bin/docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh '''
                    /usr/bin/docker stop ${CONTAINER_NAME} || true
                    /usr/bin/docker rm ${CONTAINER_NAME} || true
                    /usr/bin/docker run -d --name ${CONTAINER_NAME} -p 8080:80 ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh 'curl -I http://localhost:8080'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
        cleanup {
            script {
                sh '/usr/bin/docker stop ${CONTAINER_NAME} || true && docker rm ${CONTAINER_NAME} || true'
            }
        }
    }
}
