#!/bin/bash
#Se espera que haya un volumen compartido con el codigo en /var/local/portal

PATH_PORTAL=/var/local/portal
if [ ! -d "$PATH_PORTAL" ]; then
	echo "Falta cargar el volumen en /var/local/portal"
fi

cd $PATH_PORTAL

if [ -z "$SYMFONY_ENV" ]; then
    export SYMFONY_ENV=prod;
fi

if [ $SYMFONY_ENV="prod" ]; then
	composer install --no-dev
else
	composer install --dev
fi

