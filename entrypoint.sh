#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

NCA_LAYER_ARCHIVE="ncalayer.zip"
NCA_LAYER_DIR="ncalayer"
NCA_LAYER_SCRIPT="ncalayer.sh"
TEMP_DIR="/tmp/entrypoint"
mkdir -p "$TEMP_DIR"

export XDG_RUNTIME_DIR="$TEMP_DIR"
export XDG_SESSION_TYPE="wayland"
export WAYLAND_DISPLAY="wayland-1"
export DISPLAY=":0"

# Starting sway.
WLR_BACKENDS="headless" \
  WLR_RENDERER="pixman" \
  WLR_LIBINPUT_NO_DEVICES="1" \
  sway -c "sway.conf" --unsupported-gpu &

# Starting vnc server.
wayvnc &

# Downloading ncalayer archive.
yarn install

echo "Downloading ncalayer archive"
yarn download

# Unpacking ncalayer archive.
rm -rf "$NCA_LAYER_DIR"
mkdir -p "$NCA_LAYER_DIR"
unzip "$NCA_LAYER_ARCHIVE" -d "$NCA_LAYER_DIR"

# Installing ncalayer.
cd "$NCA_LAYER_DIR"
chmod +x "$NCA_LAYER_SCRIPT"

# Fixes and workarounds.
mkdir -p ~/.local/share/applications

dbus-uuidgen --ensure
export $(dbus-launch)

"./${NCA_LAYER_SCRIPT}" --nogui || :

# Staring chromium.
chromium \
  --user-data-dir="${TEMP_DIR}" \
  --enable-features="UseOzonePlatform" \
  --ozone-platform="wayland" \
  --disable-dev-shm-usage \
  --disabled-setupid-sandbox \
  --no-sandbox \
  --start-maximized \
  &

wait
