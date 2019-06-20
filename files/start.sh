#!/usr/bin/env bash
# -*- coding: UTF8 -*-

DB=/koel/db/koel.sqlite

if [ "$ADMIN_EMAIL" ]; then
	echo "* setup custom admin email"
	sqlite3 $DB "UPDATE users SET email = '$ADMIN_EMAIL' WHERE id=1"
fi
if [ "$ADMIN_PASSWORD" ]; then
	echo "* setup custom admin password"
	# is automatically updating dabatase from env variable
	/koel/www/artisan koel:pwd
fi
if [ "$FORCE_HTTPS" == "true" ]; then
	sed -ie 's/<?php/<?php\nURL::forceScheme("https");/' /koel/www/routes/web.php
fi
if [ "$ROOT_URL" ]; then
	sed -ie "s|<?php|<?php\nURL::forceRootUrl(\"$ROOT_URL\");|" /koel/www/routes/web.php
fi


# sync medias
if [ "$MEDIA_SYNC" != "false" ]; then
	echo "* syncing media"
	/koel/www/artisan koel:sync
fi

# finally, starts koël
/koel/www/artisan serve --host=0.0.0.0 -vvv
