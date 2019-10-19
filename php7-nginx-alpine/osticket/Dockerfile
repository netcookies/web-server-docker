FROM hinterlands/php7-nginx-alpine
LABEL maintainer "Andrew Li <andrew.li@hinterlands.tech>"

ENV TERM="xterm" \
    DB_HOST="172.17.0.1" \
    DB_NAME="" \
    DB_USER="" \
    DB_PASS="" \
    OST_VERSION=""

RUN apk update && apk add php7-imap && rm -rf /var/cache/apk/*
RUN sed -i 's/cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/g' /etc/php7/php.ini && \
    sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /etc/php7/php.ini


ADD files/default.conf /etc/nginx/conf.d/
ADD files/run-pre.sh /
RUN chmod +x /run-pre.sh

EXPOSE 80

CMD ["/run.sh"]
