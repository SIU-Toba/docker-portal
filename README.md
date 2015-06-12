# docker-portal
Contenedor Docker para crear entorno de desarrollo de SIU-Portal

## Requerimientos
 * Se debe tener instalado [Docker](https://docs.docker.com/installation/) y [Docker-compose](https://docs.docker.com/compose/install/)

## Ejecución

* Descargar el portal y entrar en la carpeta 
```
git clone URL_PORTAL portal
cd portal
```

* Copiar el archivo `docker-compose.yml` hacia la raiz del portal
* Levantar los containers usando *docker-compose*:
```
docker-compose up
```

Alternativamente se pueden levantar los containers uno a uno:
```
#Arrancar memcached
docker run --name portal-memcached -d memcached
#Arrancar portal
docker run --name portal-web --link portal-memcached:latest -p "5000:80" siutoba/docker-portal
```



## Build
Hay un archivo `portal.sh` que contiene el script de instalación del portal, ante cualquier cambio a este script (o al Dockerfile), ejecutar lo siguiente para re-generar la imagen 
```
docker build -t="siutoba/docker-portal" .
```
Una vez hecho el push a github automáticamente se va a actualizar la imagen en el índice de [hub.docker.com](hub.docker.com)

