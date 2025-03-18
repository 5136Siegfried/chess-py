#!/bin/bash

echo "🚨 Test alerte Slack..."
curl -X POST -H 'Content-type: application/json' --data '{"text":"🚨 Test alerte Slack WAF"}' https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

echo "📩 Test alerte Email..."
aws sns publish --topic-arn arn:aws:sns:us-east-1:123456789012:waf-alerts --message "🚨 Test alerte Email WAF"

echo "📲 Test alerte Telegram..."
bash scripts/alert_telegram.sh
