pipeline {
    agent any
    
    tools {
          terraform 'terraform'
        }

    environment {
        AWS_DEFAULT_REGION = "${params.region}"
    }

    parameters {
        string(name: 'region', defaultValue: 'us-east-1', description: 'AWS region to use')
        string(name: 'environment', defaultValue: 'development', description: 'Workspace/environment file to use for deployment')
    }

    //  environment {
    //     AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    //     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    // }

    stages {
        stage('Git Checkout') {
          steps {
            echo 'Cloning the application code...'
            git branch: 'main', url: 'https://gitlab.com/anselmenumbisia/tf-pipeline-project.git'
          }
        }
        stage('format') {
            steps {
                sh 'terraform fmt'
            }
        }
        stage('validate') {
            steps {
                sh 'terraform init'
                sh 'terraform validate'
            }
        }
        stage('plan') {
            steps {
                sh 'terraform init'
                sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'
                sh 'terraform plan -out=tfplan'
                stash includes: 'tfplan', name: 'terraform-plan'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'tfplan', onlyIfSuccessful: true
                }
            }
        }
        stage('approval') {
            steps {
                input "Please review the Terraform plan and click 'Proceed' to apply it"
            }
        }
        stage('apply') {
            steps {
                unstash 'terraform-plan'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
         stage('approve destroy') {
            steps {
                input "Please review the Terraform plan and click 'Proceed' to destroy it"
            }
        }
        stage('destroy') {
            steps {
                unstash 'terraform-plan'
                sh 'terraform destroy --auto-approve'
            }
        }
       
    }
}


