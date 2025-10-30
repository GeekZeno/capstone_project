pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout your GitHub repo with credentials
                git branch: 'main',
                    credentialsId: 'github_token',
                    url: 'https://github.com/GeekZeno/capstone_project.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        echo "🚀 Initializing Terraform..."
                        terraform init -input=false
                        terraform apply -auto-approve
                    '''
                }
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
                        echo "📦 Deploying on Kubernetes..."
                        kubectl apply -f namespace.yaml
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
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
