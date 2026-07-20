#!/usr/bin/env bash
set -euo pipefail

# Collect CPU temperature readings for later analysis.
OUT_FILE="${1:-temperature.log}"

echo "timestamp,cpu_temp_c" > "$OUT_FILE"
while true; do
  timestamp="$(date --iso-8601=seconds)"
  if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
    raw_temp="$(cat /sys/class/thermal/thermal_zone0/temp)"
    temp_c="$((raw_temp / 1000))"
    echo "${timestamp},${temp_c}" >> "$OUT_FILE"
  fi
  sleep 1
done
