#!/usr/bin/env bash
set -euo pipefail

# Collect CPU frequency readings for later analysis.
OUT_FILE="${1:-frequency.log}"

echo "timestamp,cpu_freq_khz" > "$OUT_FILE"
while true; do
  timestamp="$(date --iso-8601=seconds)"
  if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]]; then
    freq_khz="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)"
    echo "${timestamp},${freq_khz}" >> "$OUT_FILE"
  fi
  sleep 1
done
