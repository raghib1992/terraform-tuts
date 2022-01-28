1. Create Jenkins multibranch job
2. Instaled- AWS Secrets Manager Credentials Provider plugin
Ref: https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials
Ref: https://plugins.jenkins.io/aws-secrets-manager-credentials-provider/
## AWS cli command for secret text:
aws secretsmanager create-secret --name 'AKIARFH3I6UWSC2SYWOH' --secret-string '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' --tags 'Key=jenkins:credentials:type,Value=string' --description 'Acme Corp Newrelic API key'
2. Add PAT to jenkins job

Service Mesh
Istio