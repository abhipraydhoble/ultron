# cicd pipeline

````
pipeline {
    agent any 
    stages {
        stage('code-pull'){
            steps {
                git branch: 'main', url: 'https://github.com/abhipraydhoble/ultron.git'
            }
        }
        
        stage('init'){
            steps {
                 withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                     sh 'terraform init'
                 }
            }
        }
        
         stage('validate'){
            steps {
                 withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                     sh 'terraform validate'
                 }
            }
        } 
        stage('apply')  { 
           steps {
                 withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                     sh 'terraform apply -auto-approve'
                 }
            }
        }
        
         stage('destroy')  { 
           steps {
                 withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                     sh 'terraform destroy -auto-approve'
                 }
            }
        }
    }
}
````
