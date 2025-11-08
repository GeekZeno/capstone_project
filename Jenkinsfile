pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('github_token')
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Checking out repository..."
                git branch: 'main', url: 'https://github.com/GeekZeno/capstone_project.git', credentialsId: 'github_token'
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

        // stage('Deploy on Kubernetes') {
        //     steps {
        //         dir('k8s') {
        //             sh '''
        //                 echo "🚀 Deploying Nginx on Kubernetes..."

        //                 # Apply ConfigMap
        //                 kubectl apply -f config-map-aws.yml

        //                 # Apply Deployment
        //                 kubectl apply -f nginx-deployment.yml

        //                 # Apply Service
        //                 kubectl apply -f nginx-service-lb.yml
        //             '''
        //         }
        //     }
        // }

        // stage('Restart Nginx') {
        //     steps {
        //         sh '''
        //             echo "🔁 Restarting Nginx pods..."
        //             kubectl rollout restart deployment nginx-deployment || true
        //         '''
        //     }
        // }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
