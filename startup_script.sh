#!/bin/bash

# Güncellemeler ve gerekli paketlerin kurulumu
echo "Updating and installing required packages..."
brew update
#brew install --cask google-cloud-sdk
#brew install kubectl

# GCP kimlik doğrulama
echo "Setting up Google Cloud SDK..."
gcloud init

# GCP kimlik dosyasını ayarlayın (Dosyanın yolunu değiştirin)
GCP_KEY_PATH="/Users/yagizgurdamar/Downloads/cs-436-421508-d538efc809bc.json"
gcloud auth activate-service-account --key-file=$GCP_KEY_PATH
gcloud config set project cs-436-421508

# Terraform kurulumu
echo "Installing Terraform..."
#brew tap hashicorp/tap
#brew install hashicorp/tap/terraform

# Terraform'u başlatma ve yapılandırma
echo "Initializing Terraform..."
terraform init

# Terraform plan ve apply
echo "Applying Terraform configuration..."
cd Terraform
terraform plan
terraform apply -auto-approve

cd .. 
# Kubernetes cluster'a erişim sağlama
echo "Setting up kubectl with GKE..."
gcloud container clusters get-credentials search-engine-cluster --region us-central1

# Docker kurulumu ve yapılandırması
echo "Installing Docker..."
brew install --cask docker

echo "Starting Docker Desktop..."
open /Applications/Docker.app

# Docker'ın başlatılmasını bekleyin
while ! docker system info > /dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 5
done

# Docker image'ini oluşturma ve yükleme
echo "Building and pushing Docker image..."
cd infinity-search-solo-master
docker build -t gcr.io/cs-436-421508/infinity-search-solo:latest .
docker push gcr.io/cs-436-421508/infinity-search-solo:latest

cd ..
# Kubernetes secret oluşturma
echo "Creating Kubernetes secret for Docker registry..."
kubectl create secret docker-registry gcr-json-key \
  --docker-server=https://gcr.io \
  --docker-username=_json_key \
  --docker-password="$(cat $GCP_KEY_PATH)" \
  --docker-email=teo.grdmr@gmail.com

# Deployment ve servis dosyalarını uygulama
echo "Applying Kubernetes configurations..."
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml

echo "Setup complete."
