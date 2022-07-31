pipeline{
    agent any

    stages{
        stage("Checkout"){
            steps{
                echo "======== Executing Checkout ========"
              git branch: 'main', changelog: false, poll: false, url: 'https://github.com/mohamedanwer006/simple-nodejs-app.git'
            }
        }

        stage("Build"){
            steps{
                echo "======== Executing Build ========="
                sh "docker build  -t mohameddev006/simple-nodejs-app:latest ."
            }
        }

        stage("stageing"){
            steps{

                echo "======== Push to Dockerhub ========"
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                     sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                     sh "docker push mohameddev006/simple-nodejs-app:latest"
                    }
               
            }
        }
// TODO Deploy stage  => run as pod on gke
    }
}