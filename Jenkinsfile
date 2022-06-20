pipeline {
    agent any
    environment {
     registry = "haarubabe/project"
     registryCredential = "dockerhub"
    }
    stages {
        stage('Build code') {
          steps {
             sh 'mvn clean install -DskipTests'
          }

          post {
             success {
                 archiveArtifacts artifacts: '**/target/*.war'
             }
        }
        }

        stage('Test code') {
           steps {
              sh 'mvn test'
            }
        }

        stage('Integration test') {
         steps {
            sh 'mvn verify -DskipUnitTests'
         }
        }

        stage('Checkstyle analysis') {
          steps {
            sh 'mvn checkstyle:checkstyle'
          }
         }


      stage("Build Docker image") {
          steps {
            script {
              dockerImage = docker.build registry + ":$BUILD_NUMBER"
            }
          }
       }

      stage("Push Docker image") {
        steps {
         script {
           docker.withRegistry( '', registryCredential) {
             dockerImage.push("$BUILD_NUMBER")
             dockerImage.push("latest")
           }
         }
        }
      }

    stage("Remove docker image") {
     steps {
       sh "docker rmi $registry:$BUILD_NUMBER"
     }
    }

    stage('Sonarcube analysis') {
      environment {
        scannerHome = tool 'MySonar'
       }

      steps {
         withSonarQubeEnv('sonar-pro') { // If you have configured more than one global server connection, you can specify its name
             sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/  \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
          }

         timeout(time: 5, unit: 'MINUTES') {
             waitForQualityGate abortPipeline:true
        }
       }
    }

    stage("Deploy kubernetes cluster with helm") {
      agent{label 'KOPS'}
      steps {
        sh "helm upgrade --install --force vprofilestack helm/vprofilecharts --set appimage=${registry}:${BUILD_NUMBER} --namespace prod --kubeconfig "~/.kube/config"
      }
    }
   }
   }
