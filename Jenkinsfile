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
                git branch: 'main', url: 'https://github.com/prashanth3516/Terraform-repo.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                cd vmss-alert
                terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                cd vmss-alert
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd vmss-alert
                terraform plan -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    try {
                        sh '''
                        cd vmss-alert
                        terraform apply -auto-approve tfplan
                        '''
                    } catch (Exception e) {
                        echo "Terraform apply failed – trying import..."
                        sh '''
                        cd vmss-alert
                        terraform import azurerm_consumption_budget_subscription.vmss_budget "/subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.Consumption/budgets/vmss-budget-alert" || true
                        terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                sh '''
                cd vmss-alert
                terraform destroy -auto-approve
                '''
            }
        }
    }
}
