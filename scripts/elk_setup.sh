#!/bin/bash
# ============================================================
# elk_setup.sh — Installation et configuration ELK Stack
# Projet NSM Lab — DIC2 Cybersécurité ESP Dakar
# ============================================================

echo "============================================"
echo "  Installation ELK Stack — NSM Lab"
echo "  Elasticsearch + Kibana + Filebeat"
echo "============================================"

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Ce script doit être exécuté en tant que root"
    exit 1
fi

# ── 1. Dépendances système ──────────────────────────────────
echo ""
echo "📦 Installation des dépendances..."
apt-get update -qq
apt-get install -y curl gnupg apt-transport-https openjdk-17-jdk

# ── 2. Ajout du dépôt Elastic ──────────────────────────────
echo ""
echo "🔑 Ajout de la clé GPG Elastic..."
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch \
    | gpg --dearmor -o /usr/share/keyrings/elastic.gpg

echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] \
https://artifacts.elastic.co/packages/8.x/apt stable main" \
    | tee /etc/apt/sources.list.d/elastic-8.x.list

apt-get update -qq

# ── 3. Installation Elasticsearch ──────────────────────────
echo ""
echo "🔍 Installation Elasticsearch..."
apt-get install -y elasticsearch

# Configuration de base
cat > /etc/elasticsearch/elasticsearch.yml << 'ESCONF'
network.host: 127.0.0.1
http.port: 9200
discovery.type: single-node
xpack.security.enabled: false
ESCONF

systemctl enable elasticsearch
systemctl start elasticsearch
echo "✅ Elasticsearch démarré sur le port 9200"

# ── 4. Installation Kibana ──────────────────────────────────
echo ""
echo "📊 Installation Kibana..."
apt-get install -y kibana

cat > /etc/kibana/kibana.yml << 'KBCONF'
server.port: 5601
server.host: "127.0.0.1"
elasticsearch.hosts: ["http://127.0.0.1:9200"]
KBCONF

systemctl enable kibana
systemctl start kibana
echo "✅ Kibana démarré sur le port 5601"

# ── 5. Installation Filebeat ────────────────────────────────
echo ""
echo "📨 Installation Filebeat..."
apt-get install -y filebeat

cat > /etc/filebeat/filebeat.yml << 'FBCONF'
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /nsm/logs/arpwatch/*.log
      - /var/log/suricata/eve.json
      - /var/log/snort/*.log

output.elasticsearch:
  hosts: ["127.0.0.1:9200"]
  index: "nsm-lab-%{+yyyy.MM.dd}"

setup.kibana:
  host: "127.0.0.1:5601"
FBCONF

systemctl enable filebeat
systemctl start filebeat
echo "✅ Filebeat démarré — collecte des logs active"

# ── 6. Résumé ───────────────────────────────────────────────
echo ""
echo "============================================"
echo "  ✅ ELK Stack installé avec succès !"
echo "============================================"
echo ""
echo "  🔍 Elasticsearch : http://127.0.0.1:9200"
echo "  📊 Kibana        : http://127.0.0.1:5601"
echo "  📨 Filebeat      : actif — envoi des logs"
echo ""
echo "  Logs collectés depuis :"
echo "  → /nsm/logs/arpwatch/"
echo "  → /var/log/suricata/eve.json"
echo "  → /var/log/snort/"
echo "============================================"
