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
		IMAGE_NAME_DEV = "${env.IMAGE_NAME}.dev"
        IMAGE_NAME_LATEST = "${env.IMAGE_BASE}:latest"
	    IMAGE_NAME_LATEST_DEV = "${env.IMAGE_BASE}:latestdev"
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
                       checkout scm
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
        stage("Create DEV Docker Image") {
                    agent any
					when {
					    branch 'dev'
						}
                    steps {
                        git credentialsId: 'angular', url: 'git@github.com:volshara85/angular_deploy.git'
                      script {
                           def dockerImage = docker.build("${env.IMAGE_NAME_DEV}", "-f ${env.DOCKERFILE_NAME} .")
                           docker.withRegistry('', 'dockerhub-creds') {
                           dockerImage.push()
                           dockerImage.push("latestdev")
                           }
                           echo "Pushed Docker Image: ${env.IMAGE_NAME_DEV}"
                        }
                      sh "docker rmi ${env.IMAGE_NAME_DEV} ${env.IMAGE_NAME_LATEST_DEV}"
                    }
		}
		stage("Create PROD Docker Image") {
		            agent any
					when {
					    branch 'prod'
						}
					steps {
					  input message: 'Finished using the web site? (Click "Proceed" to continue)'
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