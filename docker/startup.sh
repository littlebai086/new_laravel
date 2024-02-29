#!/bin/sh

if [ "$IS_GCP_ENV" != "true" ]; then
    /usr/local/bin/cloud_sql_proxy \
    -dir=/cloudsql \
    -instances=imgsortable:asia-east1:imgsortable-sql  \
    -credential_file=/cert/imgsortable-fa105fe562ee.json &

    sleep 3
fi


sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

php-fpm -D

while ! nc -w 1 -z 127.0.0.1 9000; do sleep 0.1; done;

nginx