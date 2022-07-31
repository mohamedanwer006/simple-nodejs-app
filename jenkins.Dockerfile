FROM jenkins/jenkins:lts
USER root
RUN  apt-get install -y ca-certificates curl
RUN  apt-get install -y apt-transport-https
RUN  curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN  apt-get update -y &&  apt-get install -y kubectl
USER jenkins