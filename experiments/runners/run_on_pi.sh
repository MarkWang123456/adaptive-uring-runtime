#!/usr/bin/env bash
set -euo pipefail

# Launch an experiment locally on a Raspberry Pi or similar ARM board.
CONFIG_FILE="${1:?usage: run_on_pi.sh <config-file>}"

echo "Running experiment with ${CONFIG_FILE}"
