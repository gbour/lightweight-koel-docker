FROM alpine:3.8

LABEL author="Guillaume Bour <guillaume@bour.cc>"
ENV KOEL_VERSION v3.7.2

RUN apk update && \
	apk add php7 php7-pdo_sqlite php7-zip php7-simplexml php7-curl \
		php7-session php7-tokenizer php7-fileinfo php7-ctype php7-exif composer yarn \
        bash sqlite vim curl && \
    apk --update add tar

RUN mkdir -p /koel && cd /koel && mkdir db media www
WORKDIR /koel/www

# install koel
RUN composer global require "laravel/installer"
RUN curl -SsL -o /tmp/koel.tar.gz https://github.com/phanan/koel/archive/$KOEL_VERSION.tar.gz && \
    tar --strip-components=1 -xvf /tmp/koel.tar.gz
RUN composer install --no-dev
#    fixup for database path (fixed in master)
RUN sed -ie "s/\(__DIR__.'\/..\/database\/e2e.sqlite'\)/env('DB_DATABASE', \1)/" config/database.php
#    fixup for JSON encoding.
#    API json encoding may fail if texts to-be-encoded contains invalid characters.
#    I fixed it globally in laravel framework by adding JSON_INVALID_UTF8_IGNORE options, but should be done
#    for every call instead.
RUN sed -ie "s/\($this->encodingOptions = $options\)/\1|JSON_INVALID_UTF8_IGNORE/" vendor/laravel/framework/src/Illuminate/Http/JsonResponse.php
#    adds koel:pwd command to artisan to update admin password
COPY files/Password.php app/Console/Commands
RUN sed -ie "s/commands = \[/commands = [\n        Commands\\\\Password::class,/" app/Console/Kernel.php
#    increase php memory
RUN sed -ie 's/memory_limit = 128M/memory_limit = 512M/' /etc/php7/php.ini

# init koel (w/ pre-filled values)
# database contains default values:
#   username: admin
#   email: admin@localhost
#   password: password
COPY files/env /koel/www/.env
COPY files/koel.sqlite /koel/db/
RUN php artisan koel:init && mv /koel/db/koel.sqlite /koel/koel.sqlite.orig

COPY files/start.sh /koel

# TODO: cleanup (temp, dev files, unused packages)
RUN rm -Rf /tmp/*

VOLUME ["/koel/media"]
EXPOSE 8000
CMD ["/koel/start.sh"]
