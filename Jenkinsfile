pipeline {
    agent none
    options {
        skipStagesAfterUnstable()
        skipDefaultCheckout()
    }
    environment {
        IMAGE_BASE = 'volshara85/angular'
        IMAGE_TAG = "v$BUILD_NUMBER"
        IMAGE_NAME = "${env.IMAGE_BASE}:${env.IMAGE_TAG}"
        IMAGE_NAME_LATEST = "${env.IMAGE_BASE}:latest"
        DOCKERFILE_NAME = "Dockerfile"
    }

    stages {
        stage("prepare container") {
            agent { 
                docker {
                    image 'node:12.22'
                } 
            }
            environment {
                       HOME = '.'
                    }
            stages {
                stage("install") {
                    steps {
                       git branch: 'dev', credentialsId: 'angular', url: 'git@github.com:volshara85/angulartest.git'
                       sh 'npm install'
                    }
                }
                stage("Build") {
                    steps {
                        sh 'npm run build'
                    }
                }
            }
        }
        stage("Create Docker Image") {
                    agent any
                    steps {
                        git credentialsId: 'angular', url: 'git@github.com:volshara85/angular_deploy.git'
                      script {
                           def dockerImage = docker.build("${env.IMAGE_NAME}", "-f ${env.DOCKERFILE_NAME} .")
                           docker.withRegistry('', 'dockerhub-creds') {
                           dockerImage.push()
                           dockerImage.push("latest")
                           }
                           echo "Pushed Docker Image: ${env.IMAGE_NAME}"
                        }
                      sh "docker rmi ${env.IMAGE_NAME} ${env.IMAGE_NAME_LATEST}"
                    }
        }
    }
}