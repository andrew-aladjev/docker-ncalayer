FROM ubuntu:rolling

WORKDIR /app
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt update && apt install -y \
  bash locales sway xwayland wayvnc expect bsdmainutils libnss3-tools default-jre ntfs-3g \
  dbus dbus-x11 mako-notifier notification-daemon unzip xdg-utils nodejs npm xxd wget

RUN wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" && \
  apt install -y ./google-chrome-stable_current_amd64.deb && \
  rm -f ./google-chrome-stable_current_amd64.deb

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
  echo UTC > /etc/timezone && \
  npm install --global yarn

COPY . .

ENTRYPOINT /app/entrypoint.sh
