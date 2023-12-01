# NCALayer with chromium in docker container.

```sh
docker-compose build
docker-compose down --remove-orphans
docker-compose up -d
```

It will install chromium browser and ncalayer.

Please insert your usb flash with keys and mount it to any location inside `/media` or `/mnt`.
Use VNC client to connect to `127.0.0.1:5900`, you can access KZ websites using chromium and you keys.
