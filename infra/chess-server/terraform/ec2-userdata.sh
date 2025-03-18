#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip
pip3 install flask pygame python-chess stockfish
echo "Flask installé"

# Lancer le serveur Flask
nohup python3 /home/ubuntu/chess-py/src/server.py > /home/ubuntu/server.log 2>&1 &
