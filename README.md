# docker-portal
Contenedor Docker para crear entorno de desarrollo de SIU-Portal

## Requerimientos
 * Se debe tener instalado [Docker](https://docs.docker.com/installation/)

## Build
Hay un archivo `portal.sh` que contiene el script de instalación del portal, ante cualquier cambio a este script (o al Dockerfile), ejecutar lo siguiente para re-generar la imagen 
```
docker build -t="siutoba/docker-portal" .
```
Una vez hecho el push a github automáticamente se va a actualizar la imagen en el índice de [hub.docker.com](hub.docker.com)

