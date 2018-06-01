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

echo "Installing dependencies through composer..."
curl -s https://getcomposer.org/installer | php
php composer.phar install

echo "Installing core..."
php bin/directus install:config -h $DB_HOST -n $DB_NAME -u $DB_USER -p $DB_PASS -e $MAIL_USER
sed -i "s/'transport' => 'mail'/'transport' => 'smtp'/g" api/configuration.php
LINE=$(($(grep -n "transport" api/configuration.php | cut -f1 -d:) + 1))
CONF="       'host' => '"${MAIL_URL}
CONF=${CONF}"',\n        'username' => '"${MAIL_USER}
CONF=${CONF}"',\n        'password' => '"${MAIL_PASS}
CONF=${CONF}"',\n        'port' => '"${MAIL_PORT}"',"
sed -i "${LINE}i\ ${CONF}" api/configuration.php
php bin/directus install:database
php bin/directus install:install -e $ADMIN_USER -p $ADMIN_PASS -t $SITE_NAME

echo "Install successful."
