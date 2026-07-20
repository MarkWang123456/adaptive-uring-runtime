#!/usr/bin/env bash
set -euo pipefail

# Collect aggregate CPU utilization snapshots.
OUT_FILE="${1:-cpu.log}"

printf 'timestamp,mpstat_available\n' > "$OUT_FILE"
while true; do
  timestamp="$(date --iso-8601=seconds)"
  if command -v mpstat >/dev/null 2>&1; then
    echo "${timestamp},yes" >> "$OUT_FILE"
  else
    echo "${timestamp},no" >> "$OUT_FILE"
  fi
  sleep 1
done
