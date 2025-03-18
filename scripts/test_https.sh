#!/bin/bash

echo "🔍 Vérification du certificat SSL..."
curl -v --silent https://chess.example.com 2>&1 | grep "SSL certificate"

echo "🚀 Test de la redirection HTTP → HTTPS..."
curl -I http://chess.example.com | grep "301 Moved Permanently"
