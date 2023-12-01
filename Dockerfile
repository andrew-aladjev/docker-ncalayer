FROM alpine:edge
WORKDIR /app

RUN apk add --no-cache \
  bash sway chromium xwayland wayvnc \
  ca-certificates nss nss-tools openjdk21-jre \
  coreutils dbus dbus-x11 mako libnotify unzip util-linux xxd xdg-utils \
  nodejs yarn

COPY . .

ENTRYPOINT /app/entrypoint.sh
