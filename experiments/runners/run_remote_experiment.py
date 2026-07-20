#!/usr/bin/env python3
"""Run a remote experiment from a YAML configuration."""

from __future__ import annotations

import argparse
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("config", type=Path)
    parser.add_argument("--output", type=Path, default=Path("results"))
    args = parser.parse_args()
    print(f"Would run experiment from {args.config} and write to {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
