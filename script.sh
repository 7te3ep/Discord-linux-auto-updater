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
    dpkg -i discord-latest.deb >/dev/null 2>&1 || apt-get install -f -y
fi

rm -rf "$WORKDIR"
