pipeline {
    agent any

    environment {
        VENV_DIR = 'venv'
        DOCKER_COMPOSE_FILE = '/home/devops/infra/compose.yml'
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/rafifadhlu/quiz-mobile-apps.git',
                    branch: "dev/backend",      // Jenkins auto sets this
                    credentialsId: 'github-cred-fdr'   // your GitHub PAT creds
                )
            }
        }

        stage('Setup') {
            steps {
                script {
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

        stage('Deploy') {
            when {
                branch 'main'   // only deploy if merge goes to main
            }
            steps {
                script {
                    sh '''
                        echo "Deploying Django service... 🚀"
                        cd /home/devops/infra
                        docker compose build django
                        docker compose up -d django
                        echo "Deployment finished ✅"
                    '''
                }
            }
        }
    }
}
