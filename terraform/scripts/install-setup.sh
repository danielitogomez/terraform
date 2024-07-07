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

function install_git(){
  
  sudo git --version

  status_git=$?

  if [ $status_git -eq 0 ]; then
    echo "Git is already installed."
  else
    echo "Installing git"
    sudo yum install -y git
  fi
}

function install_compose(){

  docker-compose version

  status_compose=$?

  if [ $status_compose -eq 0 ]; then
    echo "Docker compose is already installed."
  else
    echo "Installing docker compose"
    sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
}


function git_clone_compose(){

  sudo ls | grep "jenkins-model-template"

  status_git_clone_compose=$?

    if [ $status_git_clone_compose -eq 0 ]; then
      echo "Repository already cloned."
      sudo git --work-tree=$HOME/jenkins-model-template --git-dir=$HOME/jenkins-model-template/.git pull
    else
      echo "Cloning repository."
      sudo git clone https://github.com/danielitogomez/jenkins-model-template.git && sudo cp -r /jenkins-model-template/ $HOME
    fi
}


# Image already build and pushed, just need to pull and run - refactor need it.
function run_jenkins(){

 docker ps -a | grep jenkins | grep -i up

 status_jenkins=$?

    if [ $status_jenkins -eq 0 ]; then
      echo "Jenkins already up and running."
    else
      echo "Creating Jenkins container."
      docker-compose -f $HOME/jenkins-model-template/docker-compose.yaml up -d
        status_compose=$?
          if [ $status_compose -eq 0 ]; then
           echo "Compose Ok."
           exit 0
          else
           echo "Compose NOK"
           exit 1
          fi
    fi
}

# Calling functions
install_docker
install_git
install_compose
git_clone_compose
run_jenkins