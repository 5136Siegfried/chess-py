#!/bin/bash

echo "🔍 Vérification des logs WAF dans CloudWatch..."
aws logs filter-log-events \
  --log-group-name "/aws/waf/chess-waf-logs" \
  --query 'events[*].message' \
  --output table


#Requetes malveillantes
echo "🚀 Test SQL Injection"
curl -X GET "https://chess.example.com/?id=1' OR '1'='1"

echo "🚀 Test XSS"
curl -X GET "https://chess.example.com/?name=<script>alert(1)</script>"

echo "🚀 Test Rate Limiting (600 requêtes)"
for i in {1..600}; do curl -s https://chess.example.com/ & done