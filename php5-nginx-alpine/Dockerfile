FROM alpine
LABEL maintainer "Andrew Li <andrew.li@hinterlands.tech>"

ENV TERM="xterm" \
    DB_HOST="172.17.0.1" \
    DB_NAME="" \
    DB_USER=""\
    DB_PASS=""

RUN apk update && \
    apk add bash less vim nginx ca-certificates git tzdata zip \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    php5-fpm php5-json php5-zlib php5-xml php5-pdo php5-phar php5-openssl \
    php5-pdo_mysql php5-mysqli php5-gd php5-iconv php5-mcrypt php5-gmp php5-zip \
    php5-curl php5-opcache php5-ctype php5-apcu \
    php5-intl php5-bcmath php5-dom php5-xmlreader mysql-client curl && apk add -u musl && \
    rm -rf /var/cache/apk/*

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/php.ini && \
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php5/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm5 /sbin/php-fpm

ADD files/nginx.conf /etc/nginx/
ADD files/default.conf /etc/nginx/conf.d/
ADD files/php-fpm.conf /etc/php5/
ADD files/run.sh /
RUN chmod +x /run.sh

EXPOSE 80
VOLUME ["/usr"]

CMD ["/run.sh"]
