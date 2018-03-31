#!/bin/sh

ARG=" "

if [ ! -d /usr/html ] ; then
  mkdir -p /usr/html
fi

if [ -f "/usr/html/index.php" ]; then
    exit 0
fi

echo "Start downloading..."
cd /usr/html
wget -qO- $(curl -s https://api.github.com/repos/directus/directus/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep tar.gz) | tar xvz
echo "Installing..."
echo "Install successful."
