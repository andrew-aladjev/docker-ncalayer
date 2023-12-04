#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

NCA_LAYER_ARCHIVE="ncalayer.zip"
NCA_LAYER_DIR="ncalayer"
NCA_LAYER_HOME_DIR=~/"NCALayer"
NCA_LAYER_SCRIPT="ncalayer.sh"
NCA_LAYER_LOG=~/".config/NCALayer/ncalayer.log"

export XDG_RUNTIME_DIR=~
export XDG_SESSION_TYPE="wayland"
export WAYLAND_DISPLAY="wayland-1"
export DISPLAY=":0"

# Starting sway.
WLR_BACKENDS="headless" \
  WLR_RENDERER="pixman" \
  WLR_LIBINPUT_NO_DEVICES="1" \
  sway -c "sway.conf" --unsupported-gpu &

# Starting vnc server.
wayvnc "0.0.0.0" &

# Downloading ncalayer archive.
yarn install

echo "Downloading ncalayer archive"
yarn download

# Unpacking ncalayer archive.
rm -rf "$NCA_LAYER_DIR"
mkdir -p "$NCA_LAYER_DIR"
unzip "$NCA_LAYER_ARCHIVE" -d "$NCA_LAYER_DIR"

# Fixes and workarounds.
chmod +x "${NCA_LAYER_DIR}/${NCA_LAYER_SCRIPT}"
mkdir -p ~/.local/share/applications

# Starting dbus.
dbus-uuidgen --ensure
export $(dbus-launch)

# Starting mako.
mako &

# Installing ncalayer.
./install.expect "$NCA_LAYER_DIR" "$NCA_LAYER_SCRIPT"

# Starting ncalayer.
cd "$NCA_LAYER_HOME_DIR"
java \
  --module-path "/usr/lib/openjfx" \
  --add-modules "javafx.controls" \
  -Djava.security.manager=allow \
  -jar "$NCA_LAYER_SCRIPT" \
  &
tail -F -f -n +1 "$NCA_LAYER_LOG" &

# Staring chromium.
chromium \
  --enable-features="UseOzonePlatform" \
  --ozone-platform="wayland" \
  --disable-dev-shm-usage \
  --disabled-setupid-sandbox \
  --no-sandbox \
  --start-maximized \
  &

echo "ncalayer is ready"

wait
