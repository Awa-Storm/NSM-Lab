#!/bin/bash
# ============================================================
# netflow_setup.sh — Configuration collecte NetFlow
# Projet NSM Lab — DIC2 Cybersécurité ESP Dakar
# ============================================================

INTERFACE="eth0"              # Interface à surveiller
NETFLOW_DIR="/nsm/netflow"    # Dossier de stockage NetFlow
COLLECTOR_PORT="2055"         # Port du collecteur NetFlow
SOFTFLOWD_PID="/var/run/softflowd.pid"

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Ce script doit être exécuté en tant que root"
    exit 1
fi

# Création du dossier de stockage
mkdir -p "$NETFLOW_DIR"

# Installation des outils si absents
echo "📦 Vérification des outils..."
apt-get install -y softflowd nfdump 2>/dev/null

# Démarrage de softflowd — export NetFlow v5 vers collecteur local
echo "🚀 Démarrage de softflowd sur $INTERFACE..."
softflowd -i "$INTERFACE" \
    -n 127.0.0.1:"$COLLECTOR_PORT" \
    -v 5 \
    -t maxlife=60 \
    -p "$SOFTFLOWD_PID"

# Démarrage du collecteur nfpcapd
echo "📡 Démarrage du collecteur nfpcapd sur le port $COLLECTOR_PORT..."
nfcapd -w -D \
    -l "$NETFLOW_DIR" \
    -p "$COLLECTOR_PORT" \
    -t 300

echo "✅ NetFlow actif !"
echo "📁 Flux stockés dans : $NETFLOW_DIR"
echo ""
echo "📊 Pour analyser les flux :"
echo "   nfdump -R $NETFLOW_DIR -s record/bytes"
echo "   nfdump -R $NETFLOW_DIR 'proto tcp and port 80'"
