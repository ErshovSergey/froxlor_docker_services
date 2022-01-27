#!/usr/bin/env bash

touch "/etc/apache2/conf-enabled/acme.conf"
##sed -i -e "s|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 128;|"           /etc/nginx/nginx.conf
sed -i -e "/^http /a  server_names_hash_bucket_size 512;" /etc/nginx/nginx.conf

  # увеличение максимального объема файла
  sed -i -e "/^http /a  client_max_body_size 2050M;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  client_body_buffer_size 1024k;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  proxy_read_timeout 120;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  proxy_connect_timeout 120;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  client_header_timeout 3000;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  client_body_timeout 3000;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  fastcgi_buffers 8 128k;" /etc/nginx/nginx.conf
  sed -i -e "/^http /a  fastcgi_buffer_size 128k;" /etc/nginx/nginx.conf

echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> /var/spool/cron/crontabs/root
echo "15 0 * * * /usr/bin/nice -n 5 /var/customers/2fa.sh 1> /dev/null" >> /var/spool/cron/crontabs/root

echo "*/5 * * * * root /usr/bin/nice -n 5 /usr/local/bin/php -q /var/www/froxlor/scripts/froxlor_master_cronjob.php --tasks 1> /dev/null" >> /var/spool/cron/crontabs/root
echo "0 0 * * *   root /usr/bin/nice -n 5 /usr/local/bin/php -q /var/www/froxlor/scripts/froxlor_master_cronjob.php --traffic 1> /dev/null" >> /var/spool/cron/crontabs/root
echo "5 0 * * *   root /usr/bin/nice -n 5 /usr/local/bin/php -q /var/www/froxlor/scripts/froxlor_master_cronjob.php --usage_report 1> /dev/null" >> /var/spool/cron/crontabs/root
echo "0 */6 * * * root /usr/bin/nice -n 5 /usr/local/bin/php -q /var/www/froxlor/scripts/froxlor_master_cronjob.php --mailboxsize 1> /dev/null" >> /var/spool/cron/crontabs/root
echo "*/5 * * * * root /usr/bin/nice -n 5 /usr/local/bin/php -q /var/www/froxlor/scripts/froxlor_master_cronjob.php --letsencrypt 1> /dev/null" >> /var/spool/cron/crontabs/root


mkdir -p /etc/cron.d/froxlor

service nginx start
service cron  start

php-fpm
