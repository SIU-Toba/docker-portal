# docker-portal
Contenedor Docker para crear entorno de desarrollo de SIU-Portal

## Requerimientos
 * Se debe tener instalado [Docker](https://docs.docker.com/installation/)

## Ejecución

1. Descargar el portal y entrar en la carpeta 
```
git clone URL_PORTAL portal
cd portal
```
2.a) Ejecución manual: 
```
#Arrancar memcached
docker run --name portal-memcached -d memcached
#Arrancar portal
docker run --name portal-web --link portal-memcached:latest -p "5000:80" siutoba/docker-portal
```

2.b) Ejecución automática usando [docker-compose](https://docs.docker.com/compose/install/):
```
docker-compose run
```

## Build
Hay un archivo `portal.sh` que contiene el script de instalación del portal, ante cualquier cambio a este script (o al Dockerfile), ejecutar lo siguiente para re-generar la imagen 
```
docker build -t="siutoba/docker-portal" .
```
Una vez hecho el push a github automáticamente se va a actualizar la imagen en el índice de [hub.docker.com](hub.docker.com)

