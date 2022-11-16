// def instanIP = ''
// pipeline{
//        agent any

  
//   environment {
//     registry = "hossamalsankary/node-app"
//     registryCredential = 'docker_credentials'
//     ANSIBLE_PRIVATE_KEY=credentials('secritfile') 
//   }        
//     stages{

//         stage("install dependencies"){
//             parallel{
//                     stage("install Frontend dependencies"){
//                         agent {
//                                 docker {
//                                     image 'node:16-alpine'
//                                     args '-u root:root'
//                                 }
//                             }
//                         steps{
//                          sh "cat /etc/*os*"   
                         
//                         dir('./frontend'){

//                               sh 'npm install'
                          
//                         }

//                         }
//                     }
//                     stage("install backend dependencies"){
//                         agent {
//                                 docker {
//                                     image 'node:16-alpine'
//                                     args '-u root:root'
//                                 }
//                             }
//                         steps{
//                             sh 'npm install -f'
//                         }
//                     }
//                 }
     
//         }
//         stage("Test"){
          
//           parallel{
//             stage("Test Front end"){
//                         agent {
//                                 docker {
//                                     image 'node:16-alpine'
//                                     args '-u root:root'
//                                 }
//                             }
//                 steps{

//                 dir('./frontend'){
//                     sh 'npm run test'
//                 }
//                 }
//             }
//              stage("Test backend"){
//                         agent {
//                                 docker {
//                                     image 'node:16-alpine'
//                                     args '-u root:root'
//                                 }
//                             }
//                  steps{
//                 echo 'I Have no test Here'
//                  }
//             }
//           }
//         }

        
//         stage("Build"){
          
//           parallel{
//             stage("build Front end"){
//                         agent {
//                                 docker {
//                                     image 'node:16-alpine'
//                                     args '-u root:root'
//                                 }
//                             }
//                 steps{
//                 dir('./frontend'){
//                     sh 'npm run build'
//                 }
//                 }
//             }
//              stage("build backend"){
//                         agent {
//                                 docker {
//                                     image 'node:16-alpine'
//                                     args '-u root:root'
//                                 }
//                             }
//                  steps{
//                   sh 'npm run build'
//                  }
//             }
//           }
//         }
//         stage("Build Docker Image"){
//             steps{

//             script {
//                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
//                }
//             }
//         }
    

//         stage("push image"){
//             steps{
//                 script {
//                      docker.withRegistry( '', registryCredential ) {
//                             dockerImage.push()
//                      }
//                 }
//             }
//         }
//         stage("Make Sure that image "){
//             steps{

//                 sh ' docker run --name test_$BUILD_NUMBER -d -p 5000:3000 $registry:$BUILD_NUMBER '
//                 sh 'sleep 2'
//                 sh 'curl localhost:5000'
//             }
    
        
//         }

//         stage("Deply IAC "){
          

//             steps{
//             withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//               dir("terraform-aws-instance"){

//                   sh 'terraform init'
//                   sh 'terraform destroy --auto-approve'
//                  sh 'terraform apply --auto-approve'

//                 }
//              }
       
//     // some block
                
//             }
//         }

     
  
//     }

//     }
//     post{
             
//         success{

//               echo "========A executed successfully========"
//                 sh "docker stop test_$BUILD_NUMBER &&docker system prune --volumes -a -f "
//         }
//         failure{
//             echo "========A execution failed========"          
//          sh "docker stop test_$BUILD_NUMBER system prune --volumes -a -f "

//         }
//      }




// pipeline {
//   agent any
//   environment {
//     registry = "hossamalsankary/node-app"
//     registryCredential = 'docker_credentials'
//     ANSIBLE_PRIVATE_KEY = credentials('secritfile')
//   }
//   stages {

//     stage("install dependencies") {
//       parallel {
//         stage("install Frontend dependencies") {
//           agent {
//             docker {
//               image 'node:16-alpine'
//               args '-u root:root'
//             }
//           }
//           steps {
//             sh "cat /etc/*os*"

//             dir('./frontend') {

//               sh 'npm install'

//             }

//           }
//         }
//       }
//     }

//   }
//   post {
//     always {
//       echo "========always========"
//     }
//     success {
//       echo "========pipeline executed successfully ========"
//     }
//     failure {
//       echo "========pipeline execution failed========"
//     }
//   }
// }
pipeline {
  agent any

  environment {
    registry = "hossamalsankary/node-app"
    registryCredential = 'docker_credentials'
    ANSIBLE_PRIVATE_KEY = credentials('secritfile')
  }
stages {

     stage("install dependencies"){
            parallel{
                    stage("install Frontend dependencies"){
                     
                        steps{
                         
                        dir('./frontend'){

                              sh 'npm install'
                          
                        }

                        }
                    }
                    stage("install backend dependencies"){
                       
                        steps{
                            sh 'npm install -f'
                        }
                    }
                }
     
        }
    stage("Test") {

      parallel {
        stage("Test Front end") {
       
          steps {

            dir('./frontend') {
              sh 'npm run test'
            }
          }
        }
        stage("Test backend") {
          
          steps {
            echo 'I Have no test Here'
          }
        }
      }
    }

    stage("Build") {

      parallel {
        stage("build Front end") {
        
          steps {
            dir('./frontend') {
              sh 'npm run build'
            }
          }
        }
        stage("build backend") {
      
          steps {
            sh 'npm run build'
          }
        }
      }
    }
    stage("Build Docker Image") {
      steps {

        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }

    stage("push image") {
      steps {
        script {
          docker.withRegistry('', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
    stage("Make Sure that image ") {
      steps {

        sh ' docker run --name test_$BUILD_NUMBER -d -p 5000:3000 $registry:$BUILD_NUMBER '
        sh 'sleep 2'
        sh 'curl localhost:5000'
      }

    }

    stage("Deply IAC ") {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          dir("terraform-aws-instance") {
            sh 'terraform init'
            sh 'terraform destroy --auto-approve'
            sh 'terraform apply --auto-approve'
          }
        }
      }
    }
      stage("ansbile") {
        steps {
          dir("./terraform-aws-instance") {
            withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

              sh 'ansible-playbook -i ansbile/inventory/inventory --extra-vars ansible_ssh_host=$(terraform output  -raw server_ip) --extra-vars  IMAGE_NAME="{{$registry:$BUILD_NUMBER}}" --private-key=$ANSIBLE_PRIVATE_KEY ./ansbile/inventory/deploy.yml '
              // sh 'ansible-playbook -i ./ansbile/deploy/inventory   --private-key=$ANSIBLE_PRIVATE_KEY ./ansbile/deploy/deploy.yml'

            }
          }
        }
      }

  }

    // post {

    //   success {

    //     echo "========A executed successfully========"
    //     sh "docker stop test_$BUILD_NUMBER &&docker system prune --volumes -a -f "
    //   }
    //   failure {
    //     echo "========A execution failed========"
    //     sh "docker stop test_$BUILD_NUMBER system prune --volumes -a -f "

    //   }
    // }
}

