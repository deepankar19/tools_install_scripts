#!/bin/bash

#Change Host Name to Artifactory
sudo hostnamectl set-hostname Artifactory

#Perform System update
sudo apt update

#Install Docker-Compose
sudo apt install docker-compose -y

#Now execute the compose file using Docker compose command to start Artifactory Container
sudo docker-compose up -d

#Make sure Artifactory is up and running
sudo docker-compose logs --follow


#Check Artifactory is up and running by typing below command:
 #curl localhost:8081

#http://change to_artifactory_publicdns_name:8081
#default user name is admin
#password is password

#for refrence
#https://www.coachdevops.com/2023/01/install-artifactory-using-docker.html

sudo apt remove --purge openjdk-\*
sudo apt install openjdk-11-jdk
sudo apt install maven -y