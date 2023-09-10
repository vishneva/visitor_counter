pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
        timstamps()
        ansiColor('xtrem')
    }

    environment {
        TERRAFORM_FOLDER_PATH = 'terraform'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
         stage('Checkout') {
            steps {
                git branch: 'deployment', url: 'https://github.com/vishneva/visitor_counter.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_FOLDER_PATH) {
                    sh "terraform init -input=false"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_FOLDER_PATH) {
                    sh "terraform plan -out terraform.tfplan"
                    sh 'terraform show -no-color terraform.tfplan > tfplan.txt'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir(TERRAFORM_FOLDER_PATH){
                        if (params.action == 'apply') {
                            if (!params.autoApprove) {
                                def plan = readFile 'tfplan.txt'
                                input message: "Should we continue and apply the plan?",
                                parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                            }
                            sh 'terraform ${action} -input=false terraform.tfplan'
                        } else if (params.action == 'destroy') {
                            sh 'terraform ${action} --auto-approve'
                        } else {
                            error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                        }
                    }
                }
            }
        }

        stage('Terraform Output') {
            steps {
                script {
                    dir(PROJECT_FOLDER_PATH) {
                        HOST_IP = sh(returnStdout: true, script: "terraform output public_ip").trim().replaceAll('"', '')
                        echo HOST_IP
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}