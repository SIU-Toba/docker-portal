#!/bin/bash
#Se espera que haya un volumen compartido con el codigo en /var/local/portal

function change_line {
	sed "s/$1/$2/" "$3" > "$3.tmp"
	mv "$3" "$3.old"
	mv "$3.tmp" "$3"
}


PATH_PORTAL=/var/local/portal
if [ ! -d "$PATH_PORTAL/app" ]; then
	echo "Falta cargar el volumen en /var/local/portal"
fi

cd $PATH_PORTAL

PATH_PARAMETERS="$PATH_PORTAL/app/config/parameters.yml"
if [ ! -f "$PATH_PARAMETERS" ]; then
	cp "$PATH_PARAMETERS.dist" "$PATH_PARAMETERS"
	change_line 'database_driver:   pdo_mysql' 	'database_driver:   pdo_pgsql' 					"$PATH_PARAMETERS"
	change_line 'database_host:     127.0.0.1' 	'database_host:     pg' 						"$PATH_PARAMETERS"
	change_line 'database_user:     root' 		'database_user:     postgres' 					"$PATH_PARAMETERS"
	change_line 'database_port:     ~' 			'database_port:     5432'	 					"$PATH_PARAMETERS"
	change_line 'database_password: ~' 			'database_password: postgres' 					"$PATH_PARAMETERS"
	change_line 'database_password: ~' 			'database_password: postgres' 					"$PATH_PARAMETERS"
	change_line 'session_memcached_host: localhost' 'session_memcached_host: memcached' 		"$PATH_PARAMETERS"
fi

if [ -z "$SYMFONY_ENV" ]; then
    export SYMFONY_ENV=prod;
fi

if [ $SYMFONY_ENV="prod" ]; then
	composer install --no-dev
else
	composer install --dev
fi

