#!/bin/bash
# ============================================================
# capture_pcap.sh — Capture de paquets avec rotation
# Projet NSM Lab — DIC2 Cybersécurité ESP Dakar
# ============================================================

INTERFACE="eth0"          # Interface à surveiller (adapter selon la machine)
OUTPUT_DIR="/nsm/pcap"    # Dossier de stockage des PCAP
ROTATION_SIZE="100"       # Taille max par fichier en Mo
MAX_FILES="10"            # Nombre max de fichiers conservés
PREFIX="capture"          # Préfixe des fichiers

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Ce script doit être exécuté en tant que root"
    exit 1
fi

# Création du dossier si inexistant
mkdir -p "$OUTPUT_DIR"

echo "✅ Démarrage de la capture sur l'interface $INTERFACE"
echo "📁 Stockage dans : $OUTPUT_DIR"
echo "🔄 Rotation tous les ${ROTATION_SIZE}Mo — max $MAX_FILES fichiers"
echo "⏹️  Appuyez sur Ctrl+C pour arrêter"

# Lancement tcpdump avec rotation automatique
tcpdump -i "$INTERFACE" \
    -w "$OUTPUT_DIR/${PREFIX}_%Y%m%d_%H%M%S.pcap" \
    -G $((ROTATION_SIZE * 60)) \
    -C "$ROTATION_SIZE" \
    -W "$MAX_FILES" \
    -z gzip \
    -n \
    -v
