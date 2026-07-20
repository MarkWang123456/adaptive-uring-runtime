#!/usr/bin/env bash
set -euo pipefail

# Collect thermal throttling-related snapshots.
OUT_FILE="${1:-throttling.log}"

printf 'timestamp,throttling_state\n' > "$OUT_FILE"
while true; do
  timestamp="$(date --iso-8601=seconds)"
  state="unknown"
  if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state ]]; then
    state="time_in_state"
  fi
  echo "${timestamp},${state}" >> "$OUT_FILE"
  sleep 1
done
