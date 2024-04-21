pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'projet3', description: 'Nom de l\'image Docker')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Tag de l\'image Docker')
        string(name: 'VOTRE_ID_GIT', defaultValue: 'EchotherealYnov', description: 'Votre ID Git')
        string(name: 'DOCKERHUB_ID', defaultValue: 'echotherealynov', description: 'Votre ID Docker Hub')
        string(name: 'DOCKERHUB_CREDENTIALS', description: 'Nom des informations d\'identification Docker Hub')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Construction de l'image Docker
                    docker.build("${params.DOCKERHUB_ID}/${params.IMAGE_NAME}:${params.IMAGE_TAG}", '.')
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
            // Exécution du conteneur Docker
            docker.image("${params.DOCKERHUB_ID}/${params.IMAGE_NAME}:${params.IMAGE_TAG}")
                .run("-d -p 80:5000 --name ${params.IMAGE_NAME}_container -e PORT=5000")
            sleep(5)
            }
            }
        }

        stage('HTTP Request') {
            steps {
                httpRequest url: 'http://172.17.0.2', validResponseCodes: '200'
            }
        }

        stage('Execute Script Shell') {
            steps {
        script {
            // Arrêt et suppression du conteneur Docker
            sh '''
                  docker stop projet3_container
                  docker rm projet3_container
            '''
        }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
            withCredentials([usernamePassword(credentialsId: params.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                sh """
                    docker login -u \$DOCKERHUB_USERNAME -p \$DOCKERHUB_PASSWORD
                    docker tag ${params.DOCKERHUB_ID}/${params.IMAGE_NAME}:${params.IMAGE_TAG} ${params.DOCKERHUB_ID}/${params.IMAGE_NAME}:${params.IMAGE_TAG}
                    docker push ${params.DOCKERHUB_ID}/${params.IMAGE_NAME}:${params.IMAGE_TAG}
                """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed :('
        }
    }
}
