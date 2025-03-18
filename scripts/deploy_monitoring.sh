#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "🚀 Déploiement complet du monitoring..."

# 1️⃣ Déploiement de l'infrastructure avec Terraform
echo "📦 Déploiement de l'infrastructure..."
cd chess-server/terraform
terraform init
terraform apply -auto-approve

# Récupérer l'IP de l'instance EC2
INSTANCE_IP=$(terraform output -raw instance_ip)
echo "🌍 Serveur EC2 déployé sur : $INSTANCE_IP"

cd ../..

# 2️⃣ Déploiement Docker
echo "🐳 Lancement des services Docker..."
cd chess-server
docker-compose up -d

# 3️⃣ Test automatique du monitoring
cd ..
echo "🔍 Test automatique du monitoring..."
bash test_monitoring.sh

echo "✅ Déploiement terminé avec succès !"
echo "🌍 Accès Prometheus : http://localhost:9090"
echo "🌍 Accès Grafana : http://localhost:3000"
echo "🌍 Accès Alertmanager : http://localhost:9093"
