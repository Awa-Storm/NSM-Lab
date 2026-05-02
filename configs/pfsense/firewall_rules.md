# Règles Pare-feu pfSense — NSM Lab

> DIC2 Cybersécurité — ESP Dakar  
> Les adresses IP ont été anonymisées

---

## Architecture
WAN (Internet)
↓
pfSense (pare-feu + routeur)
↓
LAN (réseau interne du labo)
↓
Switch SPAN → Sonde Kali Linux

---

## Règles configurées

### Interface WAN
| Action | Protocole | Source | Destination | Port | Description |
|--------|-----------|--------|-------------|------|-------------|
| Bloquer | Tout | Any | LAN | Any | Bloquer trafic entrant non sollicité |
| Autoriser | TCP | Any | WAN | 443 | HTTPS sortant autorisé |
| Autoriser | TCP | Any | WAN | 80 | HTTP sortant autorisé |
| Autoriser | UDP | Any | WAN | 53 | DNS autorisé |

### Interface LAN
| Action | Protocole | Source | Destination | Port | Description |
|--------|-----------|--------|-------------|------|-------------|
| Autoriser | TCP | LAN | Any | 22 | SSH autorisé |
| Autoriser | ICMP | LAN | Any | - | Ping autorisé |
| Autoriser | TCP | LAN | Any | 9200 | Elasticsearch |
| Autoriser | TCP | LAN | Any | 5601 | Kibana |
| Bloquer | Tout | Any | Any | Any | Bloquer tout le reste |

---

## Export des logs vers rsyslog

```bash
# /etc/rsyslog.conf — redirection logs pfSense
*.* @127.0.0.1:514
```

---

## Résultats observés

- Logs pare-feu collectés en temps réel via rsyslog
- Événements filtrés et indexés dans Elasticsearch
- Visualisation dans Kibana avec champs enrichis
- Corrélation avec alertes Suricata et Snort 3
