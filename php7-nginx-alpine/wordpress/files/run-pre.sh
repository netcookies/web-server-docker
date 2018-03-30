#!/bin/sh

ARG=" "

if [ ! -d /usr/html ] ; then
  mkdir -p /usr/html
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

cd /usr/html
wp-cli core download $ARG
while [ ! -f "/usr/html/wp-config.php" ]; do
    wp-cli core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --dbprefix=wp_
    sleep 1
done

RESULT=1
while [ $RESULT -ne 0 ]; do
    RESULT=`wp-cli core install --url="http://${WP_DOMAIN}" --title="Wordpress Stage" --admin_user="${DB_USER}" --admin_password="${DB_PASS}" --admin_email="${WP_EMAIL}" | grep -ic "error"`
    sleep 1
done

echo "/**" >> wp-config.php
echo " * Handle SSL reverse proxy" >> wp-config.php
echo " */" >> wp-config.php
echo 'if ($_SERVER'"['HTTP_X_FORWARDED_PROTO'] == 'https')" >> wp-config.php
echo '    $_SERVER'"['HTTPS']='on';" >> wp-config.php
echo "if (isset("'$_SERVER'"['HTTP_X_FORWARDED_HOST'])) {" >> wp-config.php
echo '    $_SERVER'"['HTTP_HOST'] = "'$_SERVER'"['HTTP_X_FORWARDED_HOST'];" >> wp-config.php
echo "}" >> wp-config.php
