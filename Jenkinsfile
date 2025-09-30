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
        
        stage('Setup') {
            steps {
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

        // stage('Test') {
        //     steps {
        //         sh '''
        //             echo "Running tests... 🔍🔍🔍"
        //             cd backend
        //             . ${VENV_DIR}/bin/activate
        //             cd api
        //             pytest
        //         '''
        //     }
        // }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sshagent(credentials: ['deploy-ssh']) {
                    sh '''
                        echo "Deploying Django service remotely... 🚀"
                        ssh -o StrictHostKeyChecking=no devops@172.17.0.1 '
                            cd /home/devops/infra/quiz-mobile-apps &&
                            git pull origin main &&
                            docker compose -f dockercompose.yml build quiz-app &&
                            docker compose -f dockercompose.yml up -d quiz-app
                        '
                        echo "Deployment finished ✅"
                    '''
                }
            }
        }


    }
}