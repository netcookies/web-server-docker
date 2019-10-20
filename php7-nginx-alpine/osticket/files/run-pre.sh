#!/bin/sh

ARG=" "

if [ ! -d /usr/html ] ; then
  mkdir -p /usr/html
fi

if [ -f "/usr/html/include/ost-config.php" ]; then
    if [ -f "/themes/theme.zip" ]; then
        echo "Theme file detected. Installing..."
        echo "Backing up current theme..."
        now=$(date +"%Y%m%d")
        tar czvf "backup_$now.tar.gz" /usr/html/
        mv backup_$now.tar.gz /themes
        echo "Theme installing..."
        mkdir -p /install
        cd /install
        mv /themes/theme.zip /install/theme.zip
        unzip -qq theme.zip
        mv /usr/html/include/ost-config.php /install/upload/include/ost-config.php
        cp -rf /install/upload/* /usr/html/
        rm -rf /install
        echo "Theme install successful."
    fi
    if [ 1 -eq $(grep -c "define('OSTINSTALLED',TRUE);" /usr/html/include/ost-config.php) ]; then
        rm -rf /usr/html/setup/
        rm -rf /usr/html/include/ost-sampleconfig.php
        exit 0
    fi
fi

if [ -z "$OST_VERSION" ]; then
    echo 'The following environment variables need to set: OST_VERSION '
    exit 1
fi

echo "Start downloading..."
curl -OL https://github.com/osTicket/osTicket/releases/download/v${OST_VERSION}/osTicket-v${OST_VERSION}.zip
echo "Extracting..."
unzip -qq osTicket-v${OST_VERSION}.zip
cp -rf upload/* /usr/html/
mv /usr/html/include/ost-sampleconfig.php /usr/html/include/ost-config.php
rm -rf upload
rm -rf scripts
rm -rf osTicket-v${OST_VERSION}.zip
echo "Extract successful."


