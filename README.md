# docker-ssp
Docker compose project to ease the deployment of the Student Success Platform 

## Prerequisites

* Docker Engine 2.1 or superior
* Docker Compose

## How to deploy?

* On a terminal run the following:

```
$ docker-compose up -d
```

* During the first time execution, it takes time to deploy the whole platform due to compilation time. See the container logs by running the following on the terminal:

```
$ docker logs dockerssp_ssp
```

* Once Tomcat is up and running, the platform is available at [http://localhost:8080/ssp-platoform](http://localhost:8080/ssp-platoform)

## How to customise installation?

* See the full documentation on how to setup the config files included in the [ssp/ssp-local](ssp/ssp-local) directory
* For custom Apache Tomcat configuration, you can edit the files included in the [ssp/conf](ssp/conf) directory

## Licence

This project is published under the [Apache Licence 2.0](LICENSE)
