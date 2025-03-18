#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "🚀 Déploiement complet de l'infrastructure et des conteneurs..."

# 1️⃣ Déploiement Terraform
echo "📦 Initialisation de Terraform..."
cd chess-server/terraform
terraform init
terraform plan -var-file=tfvars/dev.tfvars
terraform apply -auto-approve -var-file=tfvars/dev.tfvars

# Récupérer l'IP de l'instance EC2
INSTANCE_IP=$(terraform output -raw instance_ip)
echo "🌍 Serveur EC2 déployé sur : $INSTANCE_IP"

cd ../..

# 2️⃣ Lancer Docker sur l'instance EC2 via SSH
echo "🐳 Déploiement Docker sur l'instance EC2..."
ssh -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP << EOF
    cd chess-server
    docker-compose up --build -d
EOF

# 3️⃣ Vérifier les services
echo "📦 Conteneurs actifs sur l'instance EC2 :"
ssh ubuntu@$INSTANCE_IP "docker ps"

echo "✅ Déploiement terminé avec succès !"
echo "🌍 Accès à l'application : http://$INSTANCE_IP:5000"
