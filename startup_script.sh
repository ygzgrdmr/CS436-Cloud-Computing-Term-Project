#!/bin/bash
# Güncellemeler ve gerekli paketlerin kurulumu
sudo apt update
sudo apt install -y git docker.io python3 python3-pip

# Docker servislerinin başlatılması
sudo systemctl start docker
sudo systemctl enable docker

# GitHub repo klonlama
git clone git@github.com:ygzgrdmr/CS436-Term-Project.git /home/$USER/CS436-Term-Project

# Python bağımlılıklarının kurulumu
cd /home/$USER/CS436-Term-Project/infinity-search-solo-master
pip3 install -r requirements.txt
pip3 install --upgrade jinja2 flask

# Docker image'ının oluşturulması ve çalıştırılması
sudo docker build -t my-python-app .
sudo docker run -p 5000:5000 -d my-python-app
