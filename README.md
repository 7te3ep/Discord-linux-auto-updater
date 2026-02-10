# Automatic Discord Update at System Startup (Linux)

This guide explains how to configure an automatic, non-interactive Discord update that runs at every system startup.

The script:
- Downloads the latest official Discord `.deb`
- Compares it with the installed version
- Installs the update if a newer version is available
- Runs silently with no user input

---

## Requirements

- Debian-based Linux distribution (Ubuntu, Debian, Linux Mint, etc.)
- Discord installed via `.deb`
- Root access (sudo)
- Internet connection available at boot

---

## Step 1 — Make the script executable

Download script.sh :

    chmod +x script.sh

---

## Step 2 — Install the script on the system

Copy the script to a system-wide location:

    sudo cp script.sh /usr/local/bin/discord-auto-update.sh

Ensure it is executable:

    sudo chmod +x /usr/local/bin/discord-auto-update.sh

---

## Step 3 — Create the systemd service

Create the service file:

    sudo nano /etc/systemd/system/discord-auto-update.service

Paste the following content:

    [Unit]
    Description=Automatically update Discord at boot
    After=network-online.target
    Wants=network-online.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/discord-auto-update.sh
    User=root

    [Install]
    WantedBy=multi-user.target

Save and exit.

---

## Step 4 — Enable the service

Reload systemd and enable the service:

    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl enable discord-auto-update.service

---

## Step 5 — Optional manual test

You can test the service without rebooting:

    sudo systemctl start discord-auto-update.service
    sudo systemctl status discord-auto-update.service

---

## Result

At every system startup:
- Discord is checked for updates
- A newer version is installed automatically if available
- No prompts or user interaction occur

---

## Disable / Uninstall

To completely remove the automatic update:

    sudo systemctl disable discord-auto-update.service
    sudo rm /etc/systemd/system/discord-auto-update.service
    sudo rm /usr/local/bin/discord-auto-update.sh
    sudo systemctl daemon-reload

---

## Notes

- Uses only the official Discord download endpoint
- Does not keep background processes running
- Can be adapted for other `.deb` based applications
