# Server from scratch

Add a `.env` file with a `LOCAL_IP` variable.

## Docker

```shell
docker run --rm --mount --network host type=bind,src=./nginx/nginx.conf,dst=/etc/nginx/nginx.conf --name server-from-scratch --publish 80:8000 nginx
```

## Docker compose

### Up

```shell
docker compose up --build --detach
```

### Down

```shell
docker compose down --remove-orphans --rmi all --volumes
```
