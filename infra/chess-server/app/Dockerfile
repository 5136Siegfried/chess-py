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
