pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: nodejs
            image: node:18.7.0-alpine3.16
            command:
            - cat
            tty: true

          - name: kubectl
            image: bitnami/kubectl:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/root/.kube/config
               name: kubectl-config
         
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock 
            hostPath:
              path: /var/run/docker.sock 
          - name: kubectl-config
            hostPath:
              path: /var/jenkins_home/.kube/config 
              
            
        '''
    }
  }
  stages {
    stage('Clone') {
        
      steps {
        echo "======== Executing Clone ========"
        container('nodejs') {
          git branch: 'main', changelog: false, poll: false, url: 'https://github.com/mohamedanwer006/simple-nodejs-app.git'
        }
      }
    }  
    stage('BuildImage') {
      steps {

        echo "======== Executing Build ========="
        container('docker') {
          sh "docker build  -t mohameddev006/simple-nodejs-app:latest ."
        }
      }
    }
    stage('Login-Into-Docker') {
      steps {
         withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {

                container('docker') {
          
                     sh 'docker login -u ${USERNAME} -p ${PASSWORD}'
                }
            }
     
        }
    }
     stage('Staging') {
      steps {
            echo "======== Push to Dockerhub ========"
            container('docker') {
                sh "docker push mohameddev006/simple-nodejs-app:latest"
            }
        }
     }

     stage('Deploy-To-Production') {
        steps{
            echo "======== Deploy To Prouction ========"
        // kubeconfig(credentialsId: 'a9be358c-86ab-472b-9249-0a2c4be05167', serverUrl: '10.52.0.1') {
        //     sh 'kubectl apply -f ./k8s/namespace.yaml'
        //     sh 'kubectl apply -Rf ./k8s/'
        // }

        withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'gke-cluster', contextName: '', credentialsId: 'a9be358c-86ab-472b-9249-0a2c4be05167', namespace: 'jenkins-ns', serverUrl: '10.48.0.19:50000']]) {
             
                sh 'kubectl apply -f ./k8s/namespace.yaml'
                sh 'kubectl apply -Rf ./k8s/'
       
        }
     }
    }
  }

    post {
      always {
            container('docker') {
                sh 'docker logout'
            }
        }
    }
}

// pipeline{
//     agent any

//     stages{
//         stage("Checkout"){
//             steps{
//                 echo "======== Executing Checkout ========"
//               git branch: 'main', changelog: false, poll: false, url: 'https://github.com/mohamedanwer006/simple-nodejs-app.git'
//             }
//         }

//         stage("Build"){
//             steps{
//                 echo "======== Executing Build ========="
//                 sh "docker build  -t mohameddev006/simple-nodejs-app:latest ."
//             }
//         }

//         stage("stageing"){
//             steps{

//                 echo "======== Push to Dockerhub ========"
//                 withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
//                      sh "docker login -u ${USERNAME} -p ${PASSWORD}"
//                      sh "docker push mohameddev006/simple-nodejs-app:latest"
//                     }
               
//             }
//         }
// // TODO Deploy stage  => run as pod on gke
//     }
// }
