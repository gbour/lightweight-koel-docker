FROM alpine

RUN apk update && \
	apk add php7 php7-pdo_sqlite php7-zip composer

RUN composer global require "laravel/installer"

#ENV PATH="${PATH}:/root/.composer/vendor/bin"
#RUN laravel new foobar
#RUN apk add php7-xmlwriter php7-dom php7-xml
#RUN composer create-project laravel/laravel foobar

#RUN apk add yarn
RUN apk add nodejs git
#RUN mkdir /var/www/koel

#RUN cd /var/www/koel
#TODO: branch as variable => tag
RUN git clone --depth 1 --branch v3.7.2 https://github.com/phanan/koel.git /var/www/koel

RUN apk add php7-simplexml php7-curl
RUN cd /var/www/koel && composer install --no-dev

RUN apk add php7-ctype yarn

# .env file .
# dbtype: sqlite-e2e
# dbpath: /tmp/koel.sqlite

# /!\ dnas le code, le chemin de la db est fixe!
# __DIR__.'/../database/e2e.sqlite'
# soit on patch, soit on utilise se chemin

# in db:users
# name: xxx
# email: yyy
# in db: settings
# media path: /var/www/koel/media
# 



# Success! Koel can now be run from localhost with `php artisan serve`.
# You can also scan for media with `php artisan koel:sync`.

COPY env /var/www/koel/.env
RUN mkdir -p /koel/{www,media,db}
COPY koel.sqlite /koel
RUN cd /var/www/koel && sed -e "s/\(__DIR__.'\/..\/database\/e2e.sqlite'\)/env('DB_DATABASE', \1)/" config/database.php > /tmp/database.php && mv /tmp/database.php ./config/

#RUN cd /var/www/koel && php artisan koel:init
RUN apk add php7-session php7-tokenizer php7-fileinfo

EXPOSE 8000

#NOTE: make the koel:init at start so the user can provide params he wants ?
#=> on copie la base qui contient déjà les données par défaut
#=> on fait un script de démarrage qui autorise la modif des données
#   au boot via variables d'env

# optionel ? (param env boot)
# ./artisan koel:sync


# run ./artisan serve --host=0.0.0.0
