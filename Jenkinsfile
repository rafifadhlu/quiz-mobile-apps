pipeline {
    agent any

    environment {
        VENV_DIR = 'venv'
        DOCKER_COMPOSE_FILE = '/home/devops/infra/compose.yml'
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

        stage('Deploy') {
            when {
                branch 'main'
            }
             steps {
                // stop old containers and restart with new code
                sh "docker compose -f ${DOCKER_COMPOSE_FILE} down"
                sh "docker compose -f ${DOCKER_COMPOSE_FILE} up -d"
            }
        }

    }
}