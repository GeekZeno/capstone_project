pipeline {
    agent any

    environment {
        // Define your environment variables if needed
        APP_DIR = '/var/www/html'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "📦 Checking out repository..."
                git branch: 'main',
                    credentialsId: 'github_token',
                    url: 'https://github.com/GeekZeno/capstone_project.git'
            }
        }

        stage('Configure with Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        echo "⚙️ Running Ansible Playbook..."
                        ansible-playbook -i inventory playbook.yml
                    '''
                }
            }
        }

        stage('Deploy on Kubernetes') {
            steps {
                dir('k8s') {
                    sh '''
                        echo "🚀 Deploying on Kubernetes..."
                        kubectl apply -f namespace.yaml
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
            }
        }

        stage('Restart Nginx') {
            steps {
                sh '''
                    echo "🔁 Restarting Nginx on target servers..."
                    ansible all -i ansible/inventory -m service -a "name=nginx state=restarted"
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}
