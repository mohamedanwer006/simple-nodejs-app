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
      // run the the deploy stage on master node
        agent { label 'master' }
        steps {
           echo "======== Deploy-Stage ========"
          withKubeConfig([namespace: "jenkins-ns", credentialsId: 'a9be358c-86ab-472b-9249-0a2c4be05167']) {
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

