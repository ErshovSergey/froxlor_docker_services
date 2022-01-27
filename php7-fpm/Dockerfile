FROM php:7-fpm

RUN cd /tmp/ \
  &&  apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends $buildDeps $runtimeDeps libzip-dev default-mysql-client wget cron nginx \
#  && apt-get install -y --no-install-recommends libpq-dev \
  && docker-php-ext-install  pdo_mysql zip bcmath

RUN cd /tmp/ \
  && addgroup --gid 9999 froxlorlocal \
  && adduser --no-create-home --uid 9999 --ingroup froxlorlocal --shell /bin/false --disabled-password --gecos '' froxlorlocal \
  && adduser www-data froxlorlocal \
# extrausers
  && mkdir -p /var/lib/extrausers \
  && touch /var/lib/extrausers/passwd \
  && touch /var/lib/extrausers/group \
  && touch /var/lib/extrausers/shadow \
  && chmod 640 /var/lib/extrausers/shadow 

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/php-opocache-cfg.ini

COPY nginx-site.conf /etc/nginx/sites-enabled/default
COPY entrypoint.sh /etc/entrypoint.sh

ENTRYPOINT ["/etc/entrypoint.sh"]





#RUN cd /tmp/ \
#  && docker-php-ext-install bcmath

#RUN cd /tmp/ \
#  && apt-cache search default-mysql-client
#  && apt-get update   && apt-get install -yq --no-install-recommends $buildDeps $runtimeDeps default-mysql-client

#RUN cd /tmp/ \
#  && apt-get update   && apt-get install -yq --no-install-recommends $buildDeps $runtimeDeps libzip-dev \
#  && docker-php-ext-install zip

#RUN cd / && git clone https://github.com/Kingston-kms/eset_mirror_script.git
#COPY nod32ms.conf /eset_mirror_script/nod32ms.conf
#COPY cron.php /var/spool/cron/crontabs/root
#RUN chmod 600 /var/spool/cron/crontabs/root

#ENTRYPOINT cron -f

#разработка
#RUN apt-get update && DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends wget git procps nano telnet
