FROM php:7.4-fpm-alpine

ENV BROADCAST_DRIVER=${_BROADCAST_DRIVER}
ENV PUSHER_APP_ID=${_PUSHER_APP_ID}
ENV PUSHER_APP_KEY=${_PUSHER_APP_KEY}
ENV PUSHER_APP_SECRET=${_PUSHER_APP_SECRET}
ENV PUSHER_APP_CLUSTER=${_PUSHER_APP_CLUSTER}
ENV IS_GCP_ENV $IS_GCP_ENV

RUN apk add --no-cache \
    nginx \
    wget \
    nodejs \
    npm

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# RUN apt-get update && \
#     apt-get install -y google-cloud-sdk

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

# 檢查是否在 GCP 環境中
# 如果 IS_GCP_ENV 為 true，則執行以下命令


RUN mkdir -p /cert
COPY ./cert/ /cert/
# COPY ./cert/imgsortable-fa105fe562ee.json /cert/

RUN mkdir /cloudsql
RUN chmod 777 /cloudsql

RUN mkdir -p /app
COPY . /app


# 设置环境变量
ENV BROADCAST_DRIVER=pusher

# RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
# 這一行為下面兩行

# 複製 Composer 到映像中
COPY ./docker/composer.phar /usr/local/bin/composer
# 設置 Composer 為可執行
RUN chmod a+x /usr/local/bin/composer

RUN chown -R www-data: /app
RUN chmod +x /app/docker/startup.sh

RUN cd /app && \
    /usr/local/bin/composer install --no-dev

# RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud-sql-proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy
# 设置执行权限
RUN chmod a+x /usr/local/bin/cloud_sql_proxy

CMD sh /app/docker/startup.sh
