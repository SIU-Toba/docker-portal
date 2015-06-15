#!/bin/bash
#Se espera que haya un volumen compartido con el codigo en /var/local/portal

function replace_in_file {
	sed "s/$1/$2/" "$3" > "$3.tmp"
	mv "$3" "$3.old"
	mv "$3.tmp" "$3"
}


PATH_PORTAL=/var/local/portal
if [ ! -d "$PATH_PORTAL/app" ]; then
	echo "Falta cargar el volumen en /var/local/portal"
fi
if [ -z "$SYMFONY_ENV" ]; then
    export SYMFONY_ENV=dev;
fi

echo "Usando SYMFONY_ENV=$SYMFONY_ENV"

if [ -f "$PATH_PORTAL/INSTALLED" ]; then
    PORTAL_INSTALLED=true
else
    PORTAL_INSTALLED=false
fi

cd $PATH_PORTAL

if ! $PORTAL_INSTALLED; then

    PATH_PARAMETERS="$PATH_PORTAL/app/config/parameters.yml"
    if [ ! -f "$PATH_PARAMETERS" ]; then
        echo "Generando app/config/parameters.yml..."
        cp "$PATH_PARAMETERS.dist" "$PATH_PARAMETERS"
        replace_in_file 'database_driver:   pdo_mysql' 	'database_driver:   pdo_pgsql' 					"$PATH_PARAMETERS"
        replace_in_file 'database_host:     127.0.0.1' 	'database_host:     pg' 						"$PATH_PARAMETERS"
        replace_in_file 'database_user:     root' 		'database_user:     postgres' 					"$PATH_PARAMETERS"
        replace_in_file 'database_port:     ~' 			'database_port:     5432'	 					"$PATH_PARAMETERS"
        replace_in_file 'database_password: ~' 			'database_password: postgres' 					"$PATH_PARAMETERS"
        replace_in_file 'session_memcached_host: localhost' 'session_memcached_host: memcached' 		"$PATH_PARAMETERS"
    fi

    echo "Instalando Dependencias..."
    if [ $SYMFONY_ENV="dev" ]; then
        composer install
    else
        composer install --no-dev
    fi

    echo "Instalando Portal..."
    cd $PATH_PORTAL/bin
    ./console doctrine:database:create
    ./console doctrine:schema:update --force
    ./console assetic:dump

    #Publicar en /portal
    ln -s /var/local/portal/web /var/www/html/portal

    ### TODO: Estas carpetas (y app/config) deberian estar fuera del codigo, asi se pueden montar en docker-data y separar dato de codigo
    #Permite guardar logs y cache
    #chown -R www-data $PATH_PORTAL/var/cache $PATH_PORTAL/var/logs
    #Permite al usuario HOST editar los archivos
    #chmod -R a+w $PATH_PORTAL/var/cache $PATH_PORTAL/var/logs

    touch $PATH_PORTAL/INSTALLED
fi
