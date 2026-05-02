# 🎯 Simulation d'Attaques — NSM Lab

> DIC2 Cybersécurité — ESP Dakar  
> Toutes les attaques ont été réalisées dans un environnement isolé

---

## Objectif

Valider l'infrastructure NSM en simulant des attaques réelles
et vérifier que chaque outil de détection réagit correctement.

---

## Attaques simulées

### 1. Scan de ports — Nmap
```bash
# Scan SYN furtif
nmap -sS -p 1-1000 <cible>

# Scan complet avec détection OS
nmap -A -T4 <cible>

# Scan NULL
nmap -sN <cible>

# Scan XMAS
nmap -sX <cible>
```
**Résultat :** Alertes déclenchées sur Suricata (sid:1000003) et Snort 3 (sid:2000002, 2000003, 2000004) ✅

---

### 2. Ping flood — ICMP
```bash
ping -f <cible>
ping -i 0.1 -c 1000 <cible>
```
**Résultat :** Alerte ICMP déclenchée sur Suricata et Snort 3 ✅

---

### 3. Brute Force SSH — Hydra
```bash
hydra -l root -P /usr/share/wordlists/rockyou.txt \
    ssh://<cible> -t 4
```
**Résultat :** Alerte brute force SSH déclenchée (sid:1000007, sid:2000005) ✅

---

### 4. ARP Spoofing — Arpspoof
```bash
arpspoof -i eth0 -t <cible> <passerelle>
```
**Résultat :** ARPWatch détecte l'anomalie de couche 2 ✅  
Alerte visible dans Kibana avec champs enrichis

---

### 5. Reconstruction forensique PCAP
```bash
# Vérification intégrité MD5
md5sum capture_attaque.pcap

# Analyse avec Wireshark
wireshark capture_attaque.pcap

# Filtrer une attaque spécifique
tcpdump -r capture_attaque.pcap 'tcp and port 22'

# Extraire flux TCP
tcpflow -r capture_attaque.pcap
```
**Résultat :** Reconstruction complète de chaque attaque depuis les PCAP ✅  
Vérification MD5 confirmée — intégrité des preuves garantie

---

## Résultats globaux

| Attaque | Outil de détection | Alerte déclenchée |
|---------|-------------------|-------------------|
| Scan Nmap | Suricata + Snort 3 | ✅ Oui |
| Ping flood | Suricata + Snort 3 | ✅ Oui |
| Brute force SSH | Suricata + Snort 3 | ✅ Oui |
| ARP Spoofing | ARPWatch + Suricata | ✅ Oui |
| Forensique PCAP | Wireshark + tcpdump | ✅ Validé MD5 |

---

## Conclusion

L'infrastructure NSM a détecté **100% des attaques simulées**.  
Les événements ont été correctement indexés dans Elasticsearch  
et visualisés dans Kibana avec plus de **1 300 événements/session**.
