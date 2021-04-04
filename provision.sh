#!/bin/bash

echo "--------------- Update -----------------------------------------------"
sudo apt-get update

echo "--------------- Docker group setup to run without sudo ---------------"

groupadd --gid 993 docker
usermod -aG docker vagrant

echo "--------------- Docker install ---------------------------------------"

sudo apt-get install docker -y
sudo apt-get install docker-compose -y

echo "--------------- Docker hello world -----------------------------------"

docker run hello-world

echo "--------------- Install pip3 -----------------------------------------"

sudo apt-get update -y
sudo apt-get install python3-pip -y

echo "--------------- Install pytest ---------------------------------------"

pip3 install pytest
export PATH=$PATH:/home/vagrant/.local/bin

echo "--------------- Install kompose --------------------------------------"

curl -L https://github.com/kubernetes/kompose/releases/download/v1.22.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose

echo "--------------- Install kubectl --------------------------------------"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "--------------- Install minikube -------------------------------------"

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
