pipeline {
    agent {
        docker {
            image 'python:3.12'  // official Python image
            args '-u root'       // optional: if you need root to install deps
        }
    
    }

    environment {
        VENV_DIR = 'venv'
    }

    stages {
        stage('setup') {
            steps {
                script {
                    // Setup steps go here
                    sh 'echo "Setting up the environment...🔧🔧🔧"'
                    sh "python3 -m venv ${VENV_DIR}"
                    sh "cd backend && ./${VENV_DIR}/bin/activate && cd api && pip install -r requirements.txt "
                    sh 'echo "Environment setup success and complete✅✅✅'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Test steps go here
                    sh 'echo "running test...🔍🔍🔍"'
                    sh "cd backend && ./${VENV_DIR}/bin/activate && cd api && pytest"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    def appName = 'quiz-app'
                    def buildNumber = 1.0
                    def imageTag = "${appName}:${buildNumber}"
                    docker.build(imageTag)
                }
            }
        }

    }
}