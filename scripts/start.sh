#!/usr/bin/env bash

TUNNEL_TOKEN=${TUNNEL_TOKEN:-}

PROXY=${PROXY:-}

RCLONE_CONF=${RCLONE_CONF:-}

if [ "${RCLONE_CONF}" != "" ]; then
mkdir -p $HOME/.config/rclone
curl  "${RCLONE_CONF}" -o $HOME/.config/rclone/rclone.conf
fi

#Aria2 start

$ARIA2_CONF_DIR/update_tracker.sh "$ARIA2_CONF_DIR/aria2.conf"

echo "Trackers Updated"

echo "[INFO] Start aria2 with rpc-secret"

sed -i 's|#ARIA2_CONF_DIR|'"$ARIA2_CONF_DIR"'|g' "$ARIA2_CONF_DIR/aria2.conf"

aria2c --conf-path="$ARIA2_CONF_DIR/aria2.conf" --rpc-secret="${RPC_SECRET}" --dir="${ARIA2_DOWNLOAD_DIR}" &

if [ "${PROXY}" != "" ]; then
gost -L=:1234 -F="${PROXY}" > /dev/null 2>&1 &
fi

if [ "${TUNNEL_TOKEN}" != "" ]; then
cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN &
fi

wait -n

exit $?