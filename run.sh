#!/usr/bin/env bash

docker pull ghcr.io/divyam234/scheduler

docker run --rm --name scheduler --entrypoint="bash scripts/start_teldrive.sh" -e CONCURRRENCY=1 -e ENV_CONFIG="https://vault.bhunter.tech/scheduler.env" \
 -e RCLONE_CONF="https://vault.bhunter.tech/rclone.conf" -e VAULT_AUTH="bGVnaW9uOmxlZ2lvbkA0MjA=" \
  ghcr.io/divyam234/scheduler
