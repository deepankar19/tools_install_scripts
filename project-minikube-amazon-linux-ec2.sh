#!/bin/bash

#Specification to run minikube project

#requirement
#Amazon Linux-2
#t2.medium
#15gb

DOCKER_USER="your_docker_username"
DOCKER_PASS="your_pass"
DOCKER_HOST="your_host"
#make user root
sudo su -
#install the latest Docker Engine Packages
yum update -y
amazon-linux-extras install docker -y
yum install docker -y

#Start and Enable the Docker Service
systemctl start docker
systemctl enable docker

#Install Conntrack and Minikube
yum install conntrack -y
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

#Start Minikube
sudo /usr/local/bin/minikube start --force --driver=docker

#maven install
cd /opt/
wget http://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar xvzf apache-maven-3.6.3-bin.tar.gz
touch /etc/profile.d/maven.sh [ And add the below both lines ]
echo "export MAVEN_HOME=/opt/apache-maven-3.6.3" >> maven.sh
echo "export PATH=$PATH:$MAVEN_HOME/bin" >> maven.sh

#mvn — version is not working
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn --version -y

#Git Install
yum install git -y

#Install Java 11
yum install java-11* -y

#install kubernetes
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin
cp ./kubectl $HOME/bin/kubectl
export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
source $HOME/.bashrc
kubectl version --short –client -y

#clone the project from git
git clone https://github.com/deepankar19/kubernetes_java_deployment.git

#Service 1 (shopfront)
cd shopfront/
mvn clean install -DskipTests



docker login --username=$DOCKER_USER --password=$DOCKER_PASS $DOCKER_HOST

docker build -t ${DOCKER_USER}/shopfront:latest .
docker push ${DOCKER_USER}/shopfront:latest
docker build -t ${DOCKER_USER}/productcatalogue:latest .
docker push ${DOCKER_USER}/productcatalogue:latest
docker build -t ${DOCKER_USER}/stockmanager:latest .
docker push ${DOCKER_USER}/stockmanager:latest

#install kubernetes deployment
cd kubernetes

kubectl apply -f shopfront-service.yaml
kubectl apply -f productcatalogue-service.yaml
kubectl apply -f stockmanager-service.yaml

#see pod details
kubectl get pods -A

#start kubernetes dashboard in EC2
/usr/local/bin/minikube dashboard

sudo su
kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'

#To open Kubernetes Dashboard

#http://<EC2-IP>:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/pod?namespace=default

#Hit the below command for each service in different console of EC2 for Port Forwarding
kubectl port-forward --address 0.0.0.0 svc/shopfront 8080:8010
kubectl port-forward --address 0.0.0.0 svc/productcatalogue 8090:8020
kubectl port-forward --address 0.0.0.0 svc/stockmanager 9008:8030

#To Check Outputs
heck Outputs

# http://<EC2IP>:8090/products
# http://<EC2IP>:9008/stocks


#refrence:- https://medium.com/@ritubarhate11296/minikube-project2-setup-243e64d77077