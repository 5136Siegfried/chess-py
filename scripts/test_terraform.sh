#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "🚀 Test de la stack Terraform..."

# Lancer Checkov pour la sécurité
echo "🔍 Audit sécurité avec Checkov..."
checkov -d chess-server/terraform/

# Lancer les tests Terratest
echo "🛠️ Lancement des tests Terratest..."
cd chess-server/tests
go test -v test_terraform.go

echo "✅ Tests terminés avec succès !"
