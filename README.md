# docker-portal
Contenedor Docker para crear entorno de desarrollo de SIU-Portal

## Requerimientos
 * Se debe tener instalado [Docker](https://docs.docker.com/installation/) y [Docker-compose](https://docs.docker.com/compose/install/)

## Ejecución

* Clonar este proyecto y entrar:
```
git clone https://github.com/SIU-Toba/docker-portal.git
cd docker-portal
```
* Descargar el portal-core: 
```
git clone http://gitlab.siu.edu.ar/siu-huarpe/huarpe-core.git portal-core
```
* Levantar los containers usando *docker-compose*:
```
docker-compose up
```
* Navegar hacia <http://localhost:5000>

## Notas

 * En MacOSX o Windows reemplazar localhost por la ip de boot2docker: `boot2docker ip`
 * Para volver a ejecutar la instalación, borrar el archivo `INSTALLED` y ejecutar nuevamente `docker-compose up`
 * Se puede modificar el puerto en el `docker-composer.yml`


## Build
Hay un archivo `portal.sh` que contiene el script de instalación del portal, ante cualquier cambio a este script (o al Dockerfile), ejecutar lo siguiente para re-generar la imagen 
```
docker build -t="siutoba/docker-portal" .
```
Una vez hecho el push a github automáticamente se va a actualizar la imagen en el índice de [hub.docker.com](hub.docker.com)
