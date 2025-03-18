# Utiliser une image légère de Python
FROM python:3.10-slim

# Définir le dossier de travail
WORKDIR /app

# Copier le code source
COPY . /app

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port Flask
EXPOSE 5000

# Commande de démarrage
CMD ["python", "server.py"]


FROM nginx:latest

# Copie de la config Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Expose le port HTTPS
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
