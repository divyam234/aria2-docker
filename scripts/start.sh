#!/usr/bin/env bash

RUN_CF_TUNNEL=${RUN_CF_TUNNEL:-}

PROXY=${PROXY:-}

#Aria2 start

$ARIA2_CONF_DIR/update_tracker.sh "$ARIA2_CONF_DIR/aria2.conf"

echo "Trackers Updated"

echo "[INFO] Start aria2 with rpc-secret"

sed -i 's|#ARIA2_CONF_DIR|'"$ARIA2_CONF_DIR"'|g' "$ARIA2_CONF_DIR/aria2.conf"

aria2c --conf-path="$ARIA2_CONF_DIR/aria2.conf" --rpc-secret="${RPC_SECRET}" --dir="${ARIA2_DOWNLOAD_DIR}" &

if [ "${PROXY}" != "" ]; then
gost -L=:1234 -F="${PROXY}" > /dev/null 2>&1 &
fi

if [ "${RUN_CF_TUNNEL}" != "" ]; then
cloudflared tunnel run &
fi

wait -n

exit $?