#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "🚀 Démarrage du serveur d'échecs en conteneur..."

# Aller dans le bon dossier
cd chess-server

# Lancer Docker Compose avec build
docker-compose up --build -d

# Vérifier les conteneurs actifs
echo "📦 Conteneurs actifs :"
docker ps

# Afficher les logs du serveur Flask en direct
echo "📜 Logs du serveur Flask (CTRL+C pour quitter)..."
docker logs -f chess_server &  # Exécuter en arrière-plan

# Attendre un instant pour que le serveur démarre
sleep 3

# Ouvrir un shell dans le conteneur
echo "🔧 Connexion au conteneur..."
docker exec -it chess_server /bin/sh
