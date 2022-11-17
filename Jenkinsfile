pipeline {
  agent any

  environment {
    registry = "hossamalsankary/nodejs_app"
    registryCredential = 'docker_credentials'
    ANSIBLE_PRIVATE_KEY = credentials('secritfile')
  }
  stages {
    
    
    stage("install dependencies") {

      steps {

        sh 'npm install'

      }

    }
    stage("Test") {

      steps {

        sh 'npm run  test:unit'

      }

    }

    stage("Build") {

      steps {

        sh 'npm run build'
      }

    }
    stage("Build Docker Image") {
      steps {

        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
      post{
        
          failure{
            sh '  docker system prune --volumes -a -f '
          }
      }
    }

    stage("push image to docker hup") {
      steps {
        script {
          docker.withRegistry('', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
    stage("Smoke Test ") {
      steps {

        sh ' docker run --name test_$BUILD_NUMBER -d -p 5000:8080 $registry:$BUILD_NUMBER '
        sh 'sleep 2'
        sh 'curl localhost:5000'
      }
  

    }

    stage("Deply IAC ") {
      when {
          branch 'master'
      }
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          dir("terraform-aws-instance") {
            sh 'terraform init'
            sh 'terraform destroy --auto-approve'
            sh 'terraform apply --auto-approve'
          }
        }
      }
      post {

        success {
          echo "we  successful deploy IAC"
        }
        failure {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

            dir("terraform-aws-instance") {
              sh 'terraform destroy --auto-approve'

            }
          }
        }
      }
    }
    stage("ansbile") {
      when {
          branch 'master'
      }
      steps {
        dir("./terraform-aws-instance") {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

            sh 'ansible-playbook -i ansbile/inventory/inventory --extra-vars ansible_ssh_host=$(terraform output  -raw server_ip) --extra-vars  IMAGE_NAME=$registry:$BUILD_NUMBER --private-key=$ANSIBLE_PRIVATE_KEY ./ansbile/inventory/deploy.yml '

          }
        }
      }
    }

  }

  post {
    always{
      sh 'bash ./clearDockerImages.sh'
    }
    success {
      echo "========A executed successfully========"
      sh 'bash ./clearDockerImages.sh'

    }
    failure {
           sh 'bash ./clearDockerImages.sh'
    }
  }
}