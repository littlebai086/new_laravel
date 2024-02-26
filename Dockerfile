FROM php:7.4-fpm-alpine

ENV APP_ENV=${_APP_ENV}
ENV APP_KEY=${_APP_KEY}
ENV APP_DEBUG=${_APP_DEBUG}
ENV BROADCAST_DRIVER=${_BROADCAST_DRIVER}
ENV PUSHER_APP_ID=${_PUSHER_APP_ID}
ENV PUSHER_APP_KEY=${_PUSHER_APP_KEY}
ENV PUSHER_APP_SECRET=${_PUSHER_APP_SECRET}
ENV PUSHER_APP_CLUSTER=${_PUSHER_APP_CLUSTER}

RUN apk add --no-cache nginx wget

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

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

RUN cd /app && \
    /usr/local/bin/composer install --no-dev

RUN chown -R www-data: /app
RUN chmod +x /app/docker/startup.sh


CMD sh /app/docker/startup.sh
