pipeline {
    agent any
    environment {
        // AWS_REGION = 'us-east-2'
        // AWS_DEFAULT_REGION = 'us-east-2'
        terraformCmd = 'terraform'
        AWS_ACCESS_KEY_ID = credentials('aws-access-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        // REGION = 'ap-south-1'
    }
    parameters {
        booleanParam(name: 'run_script', defaultValue: true, description: 'when to push the code to to allow not to run script')
    }

    stages {
        stage ('Allow_script') {
            when {
                expression { params.run_script == true }
            }

            stages {
                stage('initialize terraform') {
                    steps {
                        // sh "echo AWS_REGION = \\\"${REGION}\\\" >> terraform.tfvars"
                        // sh "cat terraform.tfvars"
                        echo 'Running terraform init command'
                        sh "${terraformCmd} init"
                    }
                }

                stage('terraforma_plan') {
                    steps {
                        sh """
                            ${terraformCmd} workspace show
                            pwd;${terraformCmd} plan -out tfplan
                            pwd;${terraformCmd} show -no-color tfplan > tfplan.txt
                            """
                    }
                }

                stage('Approval') {
                    when {
                        not {
                            equals expected: true, actual: params.autoApprove
                        }
                    }
                    steps {
                        script {
                                def plan = readFile 'tfplan.txt'
                                input message: "Do you want to apply the plan?",
                                parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }
                    }
                }
                stage ('terraform_apply') {
                    steps {
                        echo 'running apply stage'
                        sh "pwd;${terraformCmd} apply -input=false tfplan"
                    }
                }
            }
        }
    }
}