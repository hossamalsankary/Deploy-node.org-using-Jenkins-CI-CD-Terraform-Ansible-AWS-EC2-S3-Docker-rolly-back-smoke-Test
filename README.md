# [nodejs.org](https://nodejs.org/)

[![CI Status](https://github.com/nodejs/nodejs.org/actions/workflows/ci.yml/badge.svg)](https://github.com/nodejs/nodejs.org/actions/workflows/ci.yml?query=branch%3Amain)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Crowdin](https://badges.crowdin.net/nodejs-website/localized.svg)](https://crowdin.com/project/nodejs-website)

## What is this repo?

[nodejs.org](https://nodejs.org/) by the [OpenJS Foundation](https://openjsf.org/) builds on the merged community's past website projects to form a self-publishing, community-managed version of the previous site.

On a technical level, inspiration has been taken from the `iojs.org` repo while design and content has been migrated from the old [nodejs.org repo](https://github.com/nodejs/nodejs.org-archive). These technical changes have helped to facilitate community involvement and empower the foundation's internationalization communities to provide alternative website content in other languages.

This repo's issues section has become the primary home for the Website WG's coordination efforts (meeting planning, minute approval, etc).

## Contributing

There are two ways to contribute to this project. The first is **submitting new features or fixing bugs** and the second is **translating content to other languages**.

In both cases the workflow is different, please check how it is done in each case.

### To submit a new feature or a bugfix

Please contribute! There are plenty of [good first issues](https://github.com/nodejs/nodejs.org/labels/good%20first%20issue) to work on. To get started, you have to [fork](https://github.com/nodejs/nodejs.org/fork) this repo to your own GitHub account first. Then open up a terminal on your machine and enter the following commands:

```bash
git clone https://github.com/<your user name>/nodejs.org.git
cd nodejs.org
npm install
npm start
```


<img src="/Blank diagram(2).png" alt="Permissions" />
 deploying node.js application to production I using Jenkins as CI/CD, Terraform as IAC, Docker, Ansible as configuration management, EC2, VPC, AWS security group,
 Build container and push to docker hub

### Project description

- environment 
```diff 
 environment {
    registry = "hossamalsankary/nodejs_app" # app name
    registryCredential = 'docker_credentials' # my docker hup credentials 
    ANSIBLE_PRIVATE_KEY = credentials('secritfile')  # for ssh connection secret.pem file 
  }
```
- Stage(1) install all required dependencies and clear the Jenkins environment
```diff 

  stage("install dependencies") {

      steps {
        sh 'npm install'
      }
      post {
        always {
          sh 'bash ./clearDockerImages.sh' # you can find this bashscript here[link]("/clearDockerImages.sh")
        }

      }

    }

```
- Stage(2) run command (npm test)  to test the code before build it
```diff 
        stage("Test") {

            steps {

              sh 'npm run  test:unit'

            }

          }
```
- Stage(3) run command (npm build)
```diff
        stage("Build") {

            steps {

              sh 'npm run build'
            }

          }
           

```

- Stage (4) build our app docker image
```diff 
    stage("Build Docker Image") {
      steps {

        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER" #  build the app  in node.js container you can find the docker file here []()
        }
      }
      post {

        failure {
          sh '  docker system prune --volumes -a -f ' # clear every thing 
        }
      }
    }
```
- Stage (5) push the docker image to the docker hub account with a different tag number
``` diff 
stage("push image to docker hup") {
      steps {
        script {
          docker.withRegistry('', registryCredential) { # this very importaint to login with registryCredential
            dockerImage.push() # now we can push the image
          }
        }
      }
    }
```
- Stage (6) smoke test in the development environment just to make the image invalid
```diff 
  stage("Test Docker Image In Dev Server ") {
      steps {
        sh ' docker run --name test_$BUILD_NUMBER -d -p 5000:8080 $registry:$BUILD_NUMBER '
        sh 'sleep 2'
        sh 'curl localhost:5000' // check if  our server is runing
      }

    }

```
- Stage (7) deploy IAC using terraform with remote state file in the s3 bucket
```diff 
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
            sh 'terraform output  -raw server_ip > tump.txt '
            script {
              serverIP = readFile('tump.txt').trim()
            }

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

```
-  Stage (8) using ansible to configure the server and install all dependency
```diff 
    stage("ansbile") {
      when {
        branch 'master'
      }
      steps {
        dir("./terraform-aws-instance") {
            # you can find this play-book here [link]()
         sh "  echo ${serverIP} "
          sh " ansible-playbook -i ansbile/inventory/inventory --extra-vars ansible_ssh_host=${serverIP} --extra-vars  IMAGE_NAME=$registry:$BUILD_NUMBER --private-key=$ANSIBLE_PRIVATE_KEY ./ansbile/inventory/deploy.yml "

        }
      }
    }
```
- Stage(10) smoke test in the production environment
```diff 
    stage("Somok test in prod server") {
        when {
        branch 'master'
      }
      steps {
        echo "${serverIP}"
        
        sh  "curl ${serverIP} "
      }
      post {

        success {
          echo "====> Somok test successful ====>"
        }
        failure {
          echo "====++++only when failed++++===="
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

            dir("terraform-aws-instance") {
             sh 'terraform destroy --auto-approve'

            }
          }
        }
      }
    }
```

- post Stage (always) clear Jenkins workspace
```diff 
-- post Stage (failure) clear Jenkins workspace and destroy IAC
-- rolly back if any stage filed
  post {
    always {
      cleanWs(cleanWhenNotBuilt: false,
        deleteDirs: true,
        disableDeferredWipeout: true,
        notFailBuild: true,
        patterns: [
          [pattern: '.gitignore', type: 'INCLUDE'],
          [pattern: '.propsfile', type: 'EXCLUDE']
        ])
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
```


 <img src="/8.png" alt="Permissions" />

 <img src="/9.png" alt="Permissions" />

 <img src="/0.png" alt="Permissions" />

 <img src="/1.png" alt="Permissions" />

 <img src="/2.png" alt="Permissions" />

 <img src="/002.png" alt="Permissions" />

 <img src="/3.png" alt="Permissions" />

 <img src="/4.png" alt="Permissions" />
 <img src="/5.png" alt="Permissions" />

 <img src="/6.png" alt="Permissions" />
 <img src="/7.png" alt="Permissions" />
 
