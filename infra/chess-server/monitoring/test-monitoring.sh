#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "🚀 Test du monitoring..."

# Vérifier si les conteneurs sont bien lancés
echo "📦 Vérification des services Docker..."
docker ps | grep -E 'prometheus|grafana|alertmanager' || { echo "❌ Un service manque !"; exit 1; }

# Vérifier que Prometheus répond bien
echo "🔍 Test de Prometheus..."
if curl -s http://localhost:9090/api/v1/status | grep -q "prometheus"; then
    echo "✅ Prometheus fonctionne"
else
    echo "❌ Prometheus ne répond pas"
    exit 1
fi

# Vérifier que Node Exporter est bien accessible
echo "🔍 Test de Node Exporter..."
if curl -s http://localhost:9100/metrics | grep -q "node_exporter"; then
    echo "✅ Node Exporter fonctionne"
else
    echo "❌ Node Exporter ne répond pas"
    exit 1
fi

# Vérifier que Grafana est bien lancé
echo "🔍 Test de Grafana..."
if curl -s http://localhost:3000/api/health | grep -q "ok"; then
    echo "✅ Grafana fonctionne"
else
    echo "❌ Grafana ne répond pas"
    exit 1
fi

# Vérifier qu'Alertmanager répond
echo "🔍 Test d'Alertmanager..."
if curl -s http://localhost:9093/api/v1/status | grep -q "alertmanager"; then
    echo "✅ Alertmanager fonctionne"
else
    echo "❌ Alertmanager ne répond pas"
    exit 1
fi

echo "🎉 Tous les services de monitoring sont opérationnels !"
