pipeline {
    agent { label "master" }
    environment {
        ECR_REGISTRY = "public.ecr.aws/s5d9z0m9"
        APP_REPO_NAME= "clarusway/to-do-app"
        PATH="/usr/local/bin/:${env.PATH}"
    }
    stages {
        stage("Run app on Docker"){
            agent{
                docker{
                    image 'node:12-alpine'
                }
            }
            steps{
                withEnv(["HOME=${env.WORKSPACE}"]) {
                    sh 'yarn install --production'
                    sh 'npm install'
                }   
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:latest" .'
                sh 'docker image ls'
            }
        }
        stage('Push Image to ECR Repo') {
            steps {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'              
                sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker pull "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
                sh 'docker run --name todo -dp 80:3000 "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
            }
        }
    }
    post {
        always {
            echo 'Deleting all local images'
            sh 'docker image prune -af'
        }
    }
}

