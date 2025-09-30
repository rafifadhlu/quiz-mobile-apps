pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    environment {
        VENV_DIR = 'venv'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    cleanWs()
                    checkout scm
                }
            }
        }

        stage('Setup for Test') {
            steps {
                sh '''
                    echo "Setting up test environment... 🔧"
                    cd backend
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    cd api
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    echo "Running tests... 🔍"
                    cd backend
                    . ${VENV_DIR}/bin/activate
                    cd api
                    pytest
                '''
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sshagent(credentials: ['atlantic-jenkins-key']) {
                    sh '''
                        echo "Deploying Django service remotely... 🚀"
                        ssh -o StrictHostKeyChecking=no -p 8444 devops@ip.atlantic-server.com'
                            cd /home/devops/infra &&
                            docker compose build django &&
                            docker compose up -d django
                        '
                        echo "Deployment finished ✅"
                    '''
                }
            }
        }
    }
}
