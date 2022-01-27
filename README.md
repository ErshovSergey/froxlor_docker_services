[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/github.com/ErshovSergey/master/LICENSE) ![Language](https://img.shields.io/badge/language-bash-yellowgreen.svg)
# Froxlor on debian8
Открытая система управления хостингом froxlor, конкретнее [froxlor Server Management Panel](https://www.froxlor.org/) на [Debian 8](https://www.debian.org/releases/stable/).

## Описание
Открытая система управления хостингом froxlor, конкретнее [froxlor Server Management Panel](https://www.froxlor.org/) запускается на [Debian 8](https://www.debian.org/releases/stable/), также доступен FTP для клиентов, точнее sftp на 21 порту. Настройки хранятся вне контейнера. Для резервного копирования можно использовать bareos-fd. 
## Эксплуатация данного проекта.
### Клонируем проект
```shell
git clone https://DockerImage@bitbucket.org/DockerImage/froxlor_docker-compose.git
```
### Настройки
Переходим в каталог. 
Необходимые настройки делаются в файлах _.env_ и _mysql.env_.

Команда для сборки контейнеров
```
docker-compose up --build -d
```
Команда для удаления контейнеров
```
docker-compose down --remove-orphans
``` 
После сборки образа и запуска необходимо включить в настройка froxlor _"Use libnss-extrausers instead of libnss-mysql"_.

docker exec -i -t <DOMANINAME>_php7_nginx bash
chown -R www-data:www-data /var/www/froxlor/

### phpmyadmin
ссылка для доступа к phpmyadmin
[http://<domain>/froxlor/phpmyadmin/](http://<domain>/froxlor/phpmyadmin/)

### Для информации
#### FTP сервер
Для доступа к файлам используется sftp сервер, в качестве сервера proftpd настроенный по [источник](https://forum.froxlor.org/index.php?/topic/12753-configuring-proftpd-to-act-as-sftp-server/).
Номер порта, на котором работает sftp сервер указывается в _.env_.

#### http сервер
По умолчанию используется в качестве http сервера используется сервер указанный в файле _.env_.
В процессе запуска используется файл из froxlor _/var/www/froxlor/install/scripts/config-services.php_.
Параметры для запуска можно создать командой
```
/var/www/froxlor/install/scripts/config-services.php --create --froxlor-dir=/var/www/froxlor/
```
[источник](https://github.com/Froxlor/Froxlor/issues/535)

### Дополнительные опции
По мотивам https://debian.pro/726
Для ограничения доступа к сайтам можно использовать опции nginx - geo. Для этого в файле /customers/ACL.conf прописываем переменную, которую потом можно использовать в правилах _Own vHost-settings:_.
Этот файл будет использован nginx так, как если бы он находился в _/etc/nginx/conf.d/_.


### Полезные команды - запуская в образе
```
/usr/bin/php  /var/www/froxlor/scripts/froxlor_master_cronjob.php --force --letsencrypt --debug
```
### Органичение по ip адресу и по паролю
#### Использование для перенаправления
добавить в свойства домена в Own vHost-settings: 
```
#error_log /var/log/nginx/error1.log debug;

rewrite ^(?!.FakeLocation) /FakeLocation$uri last;

location ^~/FakeLocation/ {
    satisfy any;

    allow 192.168.XXX.XXX/24;
    allow 1X5.XXX.X4.1/32;

    deny  all;

    auth_basic "Every day password required";
    auth_basic_user_file /var/customers/webs/InProduction/glpi.itsmpro.ru/.htpasswd;
    #error_log /var/log/nginx/error.log ;
    #access_log /var/log/nginx/access.log;
    proxy_pass   http://192.168.XXX.XXX:YY/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $http_connection;
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
}

location ^~/FakeLocation/glpi/ {
    #error_log /var/log/nginx/error.log ;
    #access_log /var/log/nginx/access.log;
    proxy_pass   http://192.168.XXX.XXX:YY/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $http_connection;
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
}
```


> Copyright (c) 2018 &lt;[ErshovSergey](http://github.com/ErshovSergey/)&gt;

> Данная лицензия разрешает лицам, получившим копию данного программного обеспечения и сопутствующей документации (в дальнейшем именуемыми «Программное Обеспечение»), безвозмездно использовать Программное Обеспечение без ограничений, включая неограниченное право на использование, копирование, изменение, добавление, публикацию, распространение, сублицензирование и/или продажу копий Программного Обеспечения, также как и лицам, которым предоставляется данное Программное Обеспечение, при соблюдении следующих условий:

> Указанное выше уведомление об авторском праве и данные условия должны быть включены во все копии или значимые части данного Программного Обеспечения.

> ДАННОЕ ПРОГРАММНОЕ ОБЕСПЕЧЕНИЕ ПРЕДОСТАВЛЯЕТСЯ «КАК ЕСТЬ», БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ, ЯВНО ВЫРАЖЕННЫХ ИЛИ ПОДРАЗУМЕВАЕМЫХ, ВКЛЮЧАЯ, НО НЕ ОГРАНИЧИВАЯСЬ ГАРАНТИЯМИ ТОВАРНОЙ ПРИГОДНОСТИ, СООТВЕТСТВИЯ ПО ЕГО КОНКРЕТНОМУ НАЗНАЧЕНИЮ И ОТСУТСТВИЯ НАРУШЕНИЙ ПРАВ. НИ В КАКОМ СЛУЧАЕ АВТОРЫ ИЛИ ПРАВООБЛАДАТЕЛИ НЕ НЕСУТ ОТВЕТСТВЕННОСТИ ПО ИСКАМ О ВОЗМЕЩЕНИИ УЩЕРБА, УБЫТКОВ ИЛИ ДРУГИХ ТРЕБОВАНИЙ ПО ДЕЙСТВУЮЩИМ КОНТРАКТАМ, ДЕЛИКТАМ ИЛИ ИНОМУ, ВОЗНИКШИМ ИЗ, ИМЕЮЩИМ ПРИЧИНОЙ ИЛИ СВЯЗАННЫМ С ПРОГРАММНЫМ ОБЕСПЕЧЕНИЕМ ИЛИ ИСПОЛЬЗОВАНИЕМ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ ИЛИ ИНЫМИ ДЕЙСТВИЯМИ С ПРОГРАММНЫМ ОБЕСПЕЧЕНИЕМ.

