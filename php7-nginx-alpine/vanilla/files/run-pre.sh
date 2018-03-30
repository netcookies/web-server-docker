#!/bin/sh

ARG=" "

if [ ! -d /usr/html ] ; then
  mkdir -p /usr/html
fi

if [ -f "/usr/html/index.php" ]; then
    exit 0
fi

if [ ! -z "$VNL_VERSION" ]; then
    echo 'The following environment variables need to set: VNL_VERSION '
    exit 1
fi


cd /usr/html
wget -qO- -O tmp.zip  https://open.vanillaforums.com/get/vanilla-core-${VNL_VERSION}.zip && unzip tmp.zip && rm tmp.zip
mv vanilla-*/* . && rm -r vanilla-*
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chmod -R 777 conf/
chmod -R 777 uploads/
chmod -R 777 cache/
