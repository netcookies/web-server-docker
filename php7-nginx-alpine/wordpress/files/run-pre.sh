#!/bin/sh

ARG=" "

if [ ! -d /usr/html ] ; then
  mkdir -p /usr/html
fi

if [ -f "/usr/html/index.php" ]; then
    exit 0
fi

if [ -z "$DOMAIN" ]; then
    echo 'The following environment variables need to set: DOMAIN '
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo 'The following environment variables need to set: EMAIL '
    exit 1
fi

if [ ! -z "$WP_VERSION" ]; then
    ARG=$ARG"--version=${WP_VERSION} "
fi

if [ ! -z "$WP_LOCALE" ]; then
    ARG=$ARG"--locale=${WP_LOCALE} "
fi

cd /usr/html
wp-cli core download $ARG
wp-cli core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --dbprefix=wp_
sleep 5
wp-cli core install --url="http://${DOMAIN}" --title='Wordpress Stage' --admin_user="${DB_USER}" --admin_password="${DB_PASS}" --admin_email="${EMAIL}"

echo "/**" >> wp-conf.php
echo " * Handle SSL reverse proxy" >> wp-conf.php
echo " */" >> wp-conf.php
echo 'if ($_SERVER'"['HTTP_X_FORWARDED_PROTO'] == 'https')" >> wp-conf.php
echo '    $_SERVER'"['HTTPS']='on';" >> wp-conf.php
echo "if (isset("'$_SERVER'"['HTTP_X_FORWARDED_HOST'])) {" >> wp-conf.php
echo '    $_SERVER'"['HTTP_HOST'] = "'$_SERVER'"['HTTP_X_FORWARDED_HOST'];" >> wp-conf.php
echo "}" >> wp-conf.php
