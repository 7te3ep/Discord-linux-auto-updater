# Discord-linux-auto-updater

Ce guide explique comment configurer une mise à jour **automatique, silencieuse et sans interaction utilisateur** de Discord **à chaque démarrage du PC**.

✔ Télécharge automatiquement la dernière version officielle  
✔ Compare la version installée avec la version disponible  
✔ Installe la mise à jour si nécessaire  
✔ Fonctionne sur Ubuntu / Debian / Linux Mint  

---

## 📋 Prérequis

- Distribution Linux basée sur Debian
- Discord installé via le paquet `.deb`
- Accès administrateur (`sudo`)
- Connexion Internet au démarrage

---

## 📁 Étape 1 — Créer le script de mise à jour

Créer le fichier du script :

    sudo nano /usr/local/bin/discord-auto-update.sh

Collez le contenu suivant :

    #!/usr/bin/env bash
    set -e

    WORKDIR="/tmp/discord-update"
    URL="https://discord.com/api/download/stable?platform=linux&format=deb"

    mkdir -p "$WORKDIR"
    cd "$WORKDIR"

    wget -q -O discord-latest.deb "$URL"

    DEB_VERSION=$(dpkg-deb -f discord-latest.deb Version)
    INSTALLED_VERSION=$(dpkg-query -W -f='${Version}' discord 2>/dev/null || echo "none")

    if [ "$DEB_VERSION" != "$INSTALLED_VERSION" ]; then
        chmod +x discord-latest.deb
        dpkg -i discord-latest.deb >/dev/null 2>&1 || apt-get install -f -y
    fi

    rm -rf "$WORKDIR"

Enregistrez et quittez (`Ctrl + O`, `Entrée`, `Ctrl + X`).

---

## 🔐 Étape 2 — Rendre le script exécutable

    sudo chmod +x /usr/local/bin/discord-auto-update.sh

---

## ⚙️ Étape 3 — Créer le service systemd

Créer le fichier du service :

    sudo nano /etc/systemd/system/discord-auto-update.service

Collez :

    [Unit]
    Description=Auto update Discord at boot
    After=network-online.target
    Wants=network-online.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/discord-auto-update.sh
    User=root

    [Install]
    WantedBy=multi-user.target

---

## 🚀 Étape 4 — Activer le service

    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl enable discord-auto-update.service

---

## 🧪 Étape 5 — Test manuel (optionnel)

    sudo systemctl start discord-auto-update.service
    sudo systemctl status discord-auto-update.service

---

## ✅ Résultat

- Discord se met à jour automatiquement au démarrage
- Aucun popup
- Aucune interaction utilisateur
- Aucun processus persistant

---

## 🛑 Désinstallation

    sudo systemctl disable discord-auto-update.service
    sudo rm /etc/systemd/system/discord-auto-update.service
    sudo rm /usr/local/bin/discord-auto-update.sh
    sudo systemctl daemon-reload

---

## ℹ️ Notes

- Utilise uniquement les sources officielles Discord
- Fonctionne même sans interface graphique
- Adaptable à d’autres logiciels `.deb`
