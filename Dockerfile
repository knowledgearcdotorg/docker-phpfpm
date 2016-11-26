FROM knowledgearcdotorg/supervisor
MAINTAINER development@knowledgearc.com

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update

RUN apt-get upgrade -y && \
    apt-get install -y php-fpm cron && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY supervisord/phpfpm.conf /etc/supervisor/conf.d/phpfpm.conf
COPY supervisord/cron.conf /etc/supervisor/conf.d/cron.conf

RUN ln /usr/sbin/php-fpm7.0 /usr/sbin/php-fpm

RUN sed \
    -i.orig \
    -e s/listen\\s=\\s\\/run\\/php\\/php7\\.0-fpm\\.sock/listen\ =\ [::]:9000/g \
    /etc/php/7.0/fpm/pool.d/www.conf

RUN echo '[global]\n\
daemonize = false\n'\
>> /etc/php/7.0/fpm/pool.d/www.conf

RUN mkdir /run/php

EXPOSE 9000
