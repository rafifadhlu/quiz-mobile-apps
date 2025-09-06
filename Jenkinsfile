pipeline {
    agent any

    environment {
        VENV_DIR = 'venv'
    }

    stages {
        stage('setup') {
            steps {
                script {
                    // Setup steps go here
                    sh '''
                        echo "Setting up the environment... 🔧🔧🔧"
                        cd backend
                        python3 -m venv ${VENV_DIR}
                        . ${VENV_DIR}/bin/activate
                        cd api
                        pip install -r requirements.txt
                        echo "Environment setup success and complete ✅✅✅"
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Test steps go here
                    sh '''
                        echo "Running tests... 🔍🔍🔍"
                        cd backend
                        . ${VENV_DIR}/bin/activate
                        cd api
                        pytest
                    '''
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