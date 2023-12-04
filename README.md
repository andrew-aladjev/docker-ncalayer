# NCALayer with chromium in docker container.

```sh
sudo docker-compose build && sudo docker-compose down --remove-orphans && sudo docker-compose up -d
```

It will install chromium browser and ncalayer.

Please wait until ncalayer will be ready using the following command:

```sh
sudo docker-compose logs -f ncalayer | grep -o "ncalayer is ready"
```

Please insert your usb flash with keys and mount it to any location inside `/media` or `/mnt`.
Use VNC client to connect to `127.0.0.1:5900`, you can access KZ websites using chromium and you keys.
