#!/bin/bash

USER="ec2-user"
HOME="/home/ec2-user"

function install_docker(){
  
  sudo docker --version

  status_docker=$?

  if [ $status_docker -eq 0 ]; then
    echo "Docker is already installed"
  else
    echo "Installing docker"
    sudo amazon-linux-extras install docker && sudo service docker start
    sudo usermod -a -G docker $USER
    sudo chkconfig docker on
  fi
}

install_docker