#!/bin/bash
#Se espera que haya un volumen compartido con el codigo en /var/local/portal

cd /var/local/portal

if [ -z "$SYMFONY_ENV" ]; then
    export SYMFONY_ENV=prod;
fi

if [ $SYMFONY_ENV="prod" ]; then
	composer install --no-dev
else
	composer install --dev
fi

