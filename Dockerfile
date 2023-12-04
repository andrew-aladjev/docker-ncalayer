FROM alpine:edge
WORKDIR /app

RUN apk add --no-cache \
  bash sway chromium xwayland wayvnc \
  ca-certificates expect nss nss-tools openjdk21-jre \
  coreutils dbus dbus-x11 mako libnotify unzip util-linux xxd xdg-utils \
  nodejs yarn

RUN apk add --no-cache \
  openjfx --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

COPY . .

ENTRYPOINT /app/entrypoint.sh
