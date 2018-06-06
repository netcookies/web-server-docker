#!/bin/sh

ARG=" "

if [ ! -d /usr/html ] ; then
  mkdir -p /usr/html
fi

if [ ! -d /db ] ; then
  mkdir -p /db
fi

if [ -f "/usr/html/index.php" ]; then
    exit 0
fi

if [ -z "$WP_DOMAIN" ]; then
    echo 'The following environment variables need to set: WP_DOMAIN '
    exit 1
fi

if [ -z "$WP_EMAIL" ]; then
    echo 'The following environment variables need to set: WP_EMAIL '
    exit 1
fi

if [ ! -z "$WP_VERSION" ]; then
    ARG=$ARG"--version=${WP_VERSION} "
fi

if [ ! -z "$WP_LOCALE" ]; then
    ARG=$ARG"--locale=${WP_LOCALE} "
fi

if [ -z "$LOCAL_DEV" ]; then
    echo "The following environment variables hasn't been set: LOCAL_DEV. Fall back to default value: 1"
    LOCAL_DEV=1
    WP_DOMAIN=http://localhost:8000
fi


cd /usr/html
wp-cli core download $ARG
while [ ! -f "/usr/html/wp-config.php" ]; do
    wp-cli core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --dbprefix=wp_
    sleep 1
done

RESULT=1
while [ $RESULT -ne 0 ]; do
    RESULT=`wp-cli core install --url="${WP_DOMAIN}" --title="Wordpress Stage" --admin_user="${DB_USER}" --admin_password="${DB_PASS}" --admin_email="${WP_EMAIL}" | grep -ic "error"`
    sleep 1
done

if [ -f "/db/dump.sql" ]; then
    wp-cli db import /db/dump.sql
    wp-cli db query "UPDATE wp_options SET option_value='${WP_DOMAIN}' WHERE option_name IN ('siteurl', 'home')"
fi

CONF="/**\n"
CONF=${CONF}" * Handle SSL reverse proxy\n"
CONF=${CONF}" */\n"
CONF=${CONF}'if ($_SERVER'"['HTTP_X_FORWARDED_PROTO'] == 'https')\n"
CONF=${CONF}'    $_SERVER'"['HTTPS']='on';\n"
CONF=${CONF}"if (isset("'$_SERVER'"['HTTP_X_FORWARDED_HOST'])) {\n"
CONF=${CONF}'    $_SERVER'"['HTTP_HOST'] = "'$_SERVER'"['HTTP_X_FORWARDED_HOST'];\n"
CONF=${CONF}"}"
sed -i "$(( $( wc -l < wp-config.php) -2 ))i\ ${CONF}" wp-config.php
