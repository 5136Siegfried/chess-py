import json
import boto3

waf_client = boto3.client("wafv2", region_name="us-east-1")

IP_SET_ID = "replace-with-your-ip-set-id"
SCOPE = "REGIONAL"

def lambda_handler(event, context):
    try:
        # Extraire l'IP malveillante du log
        ip = event["detail"]["sourceIPAddress"]

        # Récupérer les IPs actuelles
        response = waf_client.get_ip_set(Id=IP_SET_ID, Scope=SCOPE)
        current_ips = response["IPSet"]["Addresses"]

        # Ajouter la nouvelle IP si elle n'est pas déjà bannie
        if ip not in current_ips:
            current_ips.append(ip + "/32")

            # Mettre à jour l'IP set
            waf_client.update_ip_set(
                Id=IP_SET_ID,
                Scope=SCOPE,
                Addresses=current_ips
            )

            print(f"🚨 IP {ip} ajoutée à la denylist WAF.")
        else:
            print(f"ℹ️ IP {ip} déjà bloquée.")

    except Exception as e:
        print(f"❌ Erreur: {e}")

    return {
        "statusCode": 200,
        "body": json.dumps("OK")
    }
