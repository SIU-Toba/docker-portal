#!/bin/bash
#Se espera que haya un volumen compartido con el codigo en /var/local/portal

function replace_in_file {
	sed "s/$1/$2/" "$3" > "$3.new"
	mv "$3.new" "$3"
}


PORTAL_CORE_PATH=/var/local/portal/portal-core
if [ ! -d "$PORTAL_CORE_PATH/app" ]; then
	echo "Falta cargar el volumen en $PORTAL_CORE_PATH"
fi
if [ -z "$SYMFONY_ENV" ]; then
    export SYMFONY_ENV=dev;
fi
echo "Usando SYMFONY_ENV=$SYMFONY_ENV"

if [ -f "$PORTAL_CORE_PATH/INSTALLED" ]; then
    PORTAL_INSTALLED=true
else
    PORTAL_INSTALLED=false
fi

cd $PORTAL_CORE_PATH

if ! $PORTAL_INSTALLED; then

    PATH_PARAMETERS="$PORTAL_CORE_PATH/app/config/parameters.yml"
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
    cd $PORTAL_CORE_PATH/bin
    ./console doctrine:database:create
    ./console doctrine:schema:update --force
    ./console assetic:dump
    ./console simplesamlphp:config

	#Si se le pasa PORTAL_IDP_URL, registra esa url como IDP
	if [ ! -z "$PORTAL_IDP_URL" ]; then
		sed -i "s|{{idp_url}}|$PORTAL_IDP_URL|" $PORTAL_CORE_PATH/vendor/simplesamlphp/simplesamlphp/metadata/saml20-idp-remote.php
	fi

    ### TODO: Publicar vhost nuevo?
    #Publicar en DocumentRoot
    rm -rf /var/www/html
    ln -s /var/local/portal/portal-core/web /var/www/html

    ### TODO: Estas carpetas (y app/config) deberian estar fuera del codigo, asi se pueden montar en docker-data y separar dato de codigo
    #Permite guardar logs y cache
    chown -R www-data $PORTAL_CORE_PATH/var/cache $PORTAL_CORE_PATH/var/logs
    #Permite al usuario HOST editar los archivos
    chmod -R a+w $PORTAL_CORE_PATH/var/cache $PORTAL_CORE_PATH/var/logs

    touch $PORTAL_CORE_PATH/INSTALLED
fi
