# 🔐 NSM Lab — Infrastructure de Surveillance Réseau

> **Projet Académique** — DIC2 Cybersécurité, École Supérieure Polytechnique de Dakar (ESP)  
> **Équipe :** Awa NIASSE · Mame Libasse Laye SEYE · Ndeye Sona NDAO  
> **Encadrant :** Prof. Doudou Fall  

---

## 📌 Présentation

Conception et déploiement d'une **infrastructure complète de surveillance réseau (NSM)** simulant un environnement SOC réel. L'infrastructure capture, stocke et analyse l'ensemble du trafic réseau via une approche hybride : capture complète de paquets (PCAP) + flux agrégés (NetFlow) + détection d'intrusions en temps réel.

---

## 🏗️ Architecture
Routeur MikroTik → Pare-feu pfSense → Switch port SPAN → Sonde Kali Linux

---

## 📡 Stack de collecte

| Source | Outil | Rôle |
|--------|-------|------|
| Paquets bruts | `tcpdump` (rotation) | Analyse forensique |
| NetFlow | `softflowd` + `nfdump` | Métriques de trafic agrégées |
| Logs pare-feu | `pfSense` + `rsyslog` | Contexte des événements réseau |
| Couche ARP | `ARPWatch` | Détection d'anomalies et spoofing |
| Requêtes DNS | `TShark` | Intelligence applicative |
| IDS/IPS | `Suricata` + `Snort 3` | Détection d'intrusions en temps réel |

---

## 📊 Stack d'analyse

**ELK Stack**
- `Filebeat` → collecte et envoi des logs depuis toutes les sources
- `Elasticsearch` → indexation et recherche — **1 300+ événements/session**
- `Kibana` → tableaux de bord avec champs enrichis (ASN, géolocalisation, adresses)

**Détection d'intrusions**
- `Suricata` — détection par signatures + règles personnalisées
- `Snort 3` — détection parallèle avec règles local.rules
- Simulation d'attaques complète avec **reconstruction forensique depuis les PCAP** (vérification MD5)

---

## ✅ Résultats obtenus

| Indicateur | Résultat |
|------------|----------|
| Événements indexés | **1 300+ par session** |
| Moteurs de détection | Suricata + Snort 3 en parallèle |
| Validation forensique | Reconstruction PCAP complète, MD5 vérifié |
| Sources de trafic | PCAP + NetFlow + Pare-feu + ARP + DNS |
| Visualisation | Tableaux de bord Kibana avec champs enrichis |

---

## 📁 Structure du dépôt
NSM-Lab/
├── architecture/         # Schéma de topologie réseau
├── configs/
│   ├── suricata/         # Règles et configuration IDS
│   ├── snort3/           # Règles Snort 3
│   ├── filebeat/         # Configuration collecte de logs
│   └── pfsense/          # Description des règles pare-feu
├── scripts/
│   ├── capture_pcap.sh   # tcpdump avec rotation
│   ├── netflow_setup.sh  # Configuration softflowd
│   └── elk_setup.sh      # Installation ELK Stack
├── screenshots/          # Captures Kibana, Suricata, ARPWatch
├── attack-simulation/    # Scénarios d'attaques et résultats
└── docs/
└── NSM_Report.pdf    # Rapport technique complet (111 pages)

---

## 🛠️ Compétences démontrées

`Surveillance Réseau` `Infrastructure SOC` `IDS/IPS` `ELK Stack`  
`Analyse Forensique` `pfSense` `Suricata` `Snort 3` `NetFlow`  
`TShark` `ARPWatch` `Wireshark` `Administration Linux`

---

## ⚠️ Note

Les fichiers PCAP bruts et les adresses IP réelles ne sont pas inclus dans ce dépôt pour des raisons de confidentialité. Les fichiers de configuration ont été anonymisés.
