pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'httpd:latest'
        CONTAINER_NAME = 'apache-site'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Check Docker') {
            steps {
                sh 'docker ps'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 10080:80 ${DOCKER_IMAGE}
                    '''
                }
            }
        }
        stage('Get Container IP') {
            steps {
                script {
                    // Récupérer l'adresse IP du conteneur
                    env.CONTAINER_IP = sh(
                        script: "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME}",
                        returnStdout: true
                    ).trim()
                    echo "Adresse IP du conteneur : ${env.CONTAINER_IP}"
                }
            }
        }

        stage('Wait and Test HTTPS Server') {
            steps {
                script {
                    // Attendre 10 secondes pour que le serveur démarre
                    echo "Attente de 10 secondes pour que le serveur démarre..."
                    sleep 20
                    
                    // Ajouter un retry pour tester le serveur
                    retry(3) {
                        echo "Tentative de connexion au serveur HTTPS (${env.CONTAINER_IP})"
                        def response = sh(
                            script: "curl -Ik https://${env.CONTAINER_IP}:443",
                            returnStdout: true
                        ).trim()
                        echo "Réponse du serveur HTTPS : ${response}"
                    }
                }
            }
        }
        
        stage('Test HTTPS Server') {
            steps {
                script {
                    // Tester le serveur avec l'IP récupérée
                    def response = sh(
                        script: "curl -Ik http://${env.CONTAINER_IP}:80",
                        returnStdout: true
                    ).trim()
                    echo "Réponse du serveur HTTPS : ${response}"
                }
            }
        }
                
        stage('Verify Deployment') {
            steps {
                script {
                    sh 'curl -I http://${env.CONTAINER_IP}:80'
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
                sh 'docker stop ${CONTAINER_NAME} || true && docker rm ${CONTAINER_NAME} || true'
            }
        }
    }
}
