#!/bin/bash

echo "📊 Vérification des logs Grafana..."
docker logs grafana | tail -n 20

echo "🔗 Accéder à Grafana : http://localhost:3000 (user: admin, pass: SuperSecurePassword)"
