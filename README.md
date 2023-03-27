# rosi-container
Container para apostila de robótica baseada no rosi-challenge

## Instalação
Para o ambiente gráfico, é necessário a instalação do [Docker Engine](https://docs.docker.com/engine/install/), e não do Docker Desktop.

Obtenha a imagem do dockerhub:

```bash
docker pull patfiredragon/rosi-container:latest
```

Instale o [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).

Habilite conexões do docker pelo xhost:

```bash
xhost +local:docker
```

Abra um terminal no container:

```bash
docker run --rm --net=host --gpus=all -e DISPLAY=${DISPLAY} -e NVIDIA_DRIVER_CAPABILITIES="all" -it patfiredragon/rosi-container:latest
```

Teste o ambiente gráfico:

```bash
vrep
```

A interface do vrep deveria se abrir.

## Devcontainer
Um exemplo de [devcontainer](https://code.visualstudio.com/docs/devcontainers/containers):

```json
devcontainer.json

{
    "name": "rosi",
    "image": "docker.io/patfiredragon/rosi-container:latest",

    "containerEnv": {
        "DISPLAY": "${localEnv:DISPLAY}",
        "NVIDIA_DRIVER_CAPABILITIES": "all"
    },

    "runArgs": [ "--gpus=all", "--net=host" ]
}
```



