pipeline {
    agent any

    environment {
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/prashanth3516/terraform-budget-alert.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                  cd budget-alert
                  terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                  cd budget-alert
                  terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                  cd budget-alert
                  terraform plan -out=tfplan \
                    -var subscription_id=$ARM_SUBSCRIPTION_ID \
                    -var client_id=$ARM_CLIENT_ID \
                    -var client_secret=$ARM_CLIENT_SECRET \
                    -var tenant_id=$ARM_TENANT_ID
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                  cd budget-alert
                  terraform apply -auto-approve tfplan
                """
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                sh """
                  cd budget-alert
                  terraform destroy -auto-approve \
                    -var subscription_id=$ARM_SUBSCRIPTION_ID \
                    -var client_id=$ARM_CLIENT_ID \
                    -var client_secret=$ARM_CLIENT_SECRET \
                    -var tenant_id=$ARM_TENANT_ID
                """
            }
        }
    }
}
