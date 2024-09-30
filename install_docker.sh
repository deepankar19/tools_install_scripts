#!/bin/bash

if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed."
else
  os=$(uname)
#  read -p "Enter your operating system (e.g., amazon_linux, ubuntu, centos, mac): " os

  if [[ "$os" == "amazon_linux" ]]; then
   sudo yum update -y
   sudo yum install docker -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker $(USER) && newgrp docker
   docker --version
   echo "Docker has been installed successfully."
  elif [[ "$os" == "ubuntu" ]]; then

      sudo apt update -y
      sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
      sudo apt update -y
      sudo apt-cache policy docker-ce
      sudo apt install docker-ce -y
      #sudo systemctl status docker
      sudo chmod 777 /var/run/docker.sock
      echo "Docker has been installed successfully."

  elif [[ "$os" == "centos" ]]; then
       # Update the system
          sudo yum update -y
          sudo yum install -y yum-utils
          sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
          sudo yum install docker-ce docker-ce-cli containerd.io
          # Start Docker service
          sudo systemctl start docker
          # Enable Docker service to start on boot
          sudo systemctl enable docker
          echo "Docker has been installed successfully."
  else
      echo "Your operating system is not recognized."
  fi
fi