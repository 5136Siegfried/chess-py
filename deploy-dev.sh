#!/bin/bash

set -e  # Arrête l'exécution en cas d'erreur

echo "🚀 Déploiement de l'infrastructure Terraform..."

# Aller dans le dossier Terraform
cd chess-server/terraform

# Initialisation de Terraform
echo "📦 Initialisation de Terraform..."
terraform init

# Plan Terraform
echo "📜 Génération du plan Terraform..."
terraform plan -var-file=tfvars/dev.tfvars

# Application de Terraform
echo "✅ Application du plan Terraform..."
terraform apply -auto-approve -var-file=tfvars/dev.tfvars

echo "🎉 Déploiement terminé !"
